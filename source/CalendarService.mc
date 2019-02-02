using Toybox.Application;
using Toybox.Background;
using Toybox.Communications;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;

/* This module provides a calendar appointment service that works in conjunction
 * with a phone app. To use the module, the application must have the background
 * and communication permissions set in its manifest.
 *
 *
 * Setup
 *
 * - In your AppBase subclass, call registerCalendarService() in the getInitialView()
 *   function or register for temporal events yourself.
 *
 * - Add a getServiceDelegate() function and return a list that contains an instance
 *   of CalendarServiceDelegate.
 *
 * - Add an onBackgroundData(data) function and call processCalendarServiceData(data).
 *   If the function returns true, the data came from the calendar service. If not,
 *   they may have come from other delegates an need to be processed further.
 *
 *
 * Appointment Retrieval
 *
 * - To retrieve the next appointment, call getNextAppointment(). The method will
 *   return null if we have no information about a next appointment, or a Time.Moment
 *   instance otherwise.
 *
 * - Use the displayable...(...) methods to turn an appointment into a dictionary of
 *   time components that can be displayed on screen.
 */

/**
 * UTC time zone offset. Subtract from local time to get UTC time, add to
 * UTC time to get local time.
 */
const UTC_OFFSET = System.getClockTime().timeZoneOffset;

/** Identifier of the calendar service. */
const CALENDAR_SERVICE_ID = "calendarservice";

/** Property key under which the time of the most recent update is stored. */
const PROP_LAST_REFRESH = CALENDAR_SERVICE_ID + ".lastupdatetime";
/** Property key under which the next appointment data are stored. */
const PROP_NEXT_APPOINTMENT = CALENDAR_SERVICE_ID + ".nextappointment";

/** Dictionary key to identify this service as being the source of a background job result. */
const CALENDAR_SERVICE_KEY = "service";
/** Dictionary key under which the next appointment's time will be stored. */
const NEXT_APPOINTMENT_KEY = "nextappointment";

/** Message sent to the phone to request the time of the next appointment. */
const NEXT_APPOINTMENT_REQUEST = CALENDAR_SERVICE_ID + ".requestnextappointment";


/**
 * Checks whether or not the calendar service can be run on this device.
 */
function hasCalendarService() {
    return System has :ServiceDelegate;
}

/**
 * Tries to register a background process for the calendar processing. This
 * will succeed if the watch supports service delegates. Call this procedure from
 * the base app's getInitialView() function.
 *
 * @return true or false as the registration did or did not complete successfully.
 */
function registerCalendarService() {
    if (hasCalendarService()) {
        // Run the service every five minutes
        Background.registerForTemporalEvent(new Time.Duration(300));
        return true;
    } else {
        return false;
    }
}

/**
 * Processes the calendar service data if they come from the calendar service
 * in the first place.
 *
 * @return true if the data came from the calendar service and were processed
 *         by this method, false if the data should be further processed by
 *         the caller.
 */
function processCalendarServiceData(data) {
    if (data instanceof Lang.Dictionary && CALENDAR_SERVICE_ID.equals(data[CALENDAR_SERVICE_KEY])) {
        // Save the appointment
        Application.Storage.setValue(PROP_LAST_REFRESH, Time.now().value());
        Application.Storage.setValue(PROP_NEXT_APPOINTMENT, data[NEXT_APPOINTMENT_KEY]);

        return true;

    } else {
        System.println("No Calendar service return data.");
        return false;
    }
}

/**
 * Returns a Moment that specifies the time of the next appointment in local time. The
 * moment is only returned if it is in the upcoming 24 hours. If not, null is returned.
 */
function getNextAppointment() {
    // If we don't have any appointments yet, return nothing.
    var nextAppointment = Application.Storage.getValue(PROP_NEXT_APPOINTMENT);
    if (nextAppointment == null) {
        return null;
    }

    // We have an appointment in UTC time. Turn it into a moment in time in the local
    // time zone and return it if it is in the upcoming 24 hours minus 5 minutes
    var appointment = new Time.Moment(nextAppointment + UTC_OFFSET);
    var now = new Time.Moment(Time.now().value());
    var dayFromNow = now.add(new Time.Duration(Time.Gregorian.SECONDS_PER_DAY - 300));

    if (appointment.greaterThan(now) && appointment.lessThan(dayFromNow)) {
        return appointment;
    } else {
        return null;
    }
}

/**
 * Calls displayableTime(...) for the time described by this moment.
 */
function displayableMoment(moment) {
    var info = Time.Gregorian.info(moment, Time.FORMAT_SHORT);
    return displayableTime(info.hour, info.min, info.sec);
}

/**
 * Takes the given hours, minutes, and seconds and computes a dictionary of
 * values ready to be displayed on screen, honouring the 24 hours mode of
 * the device. The dictionary contains the following components:
 *
 *   :hour      A two-digit string for the hours.
 *   :minute    A two-digit string for the minutes.
 *   :second    A two-digit string for the seconds.
 *   :ampm      A possibly empty string containing "am" or "pm" if the watch
 *              is in 12 hour mode.
 */
function displayableTime(hours, minutes, seconds) {
    var amPm = "";

    // If the clock is not in 24-hour mode, we may need to adjust the hours
    // and add an am/pm indicator
    if (!System.getDeviceSettings().is24Hour) {
        if (hours >= 12) {
            amPm = "pm";

            // Noon needs to be shown as 12, not 0
            if (hours > 12) {
                hours -= 12;
            }

        } else {
            amPm = "am";

            // Midnight must be 12, not 0
            if (hours == 0) {
                hours = 12;
            }
        }
    }

    return {
        :hour => hours.format("%02d"),
        :minute => minutes.format("%02d"),
        :seconds => seconds.format("%02d"),
        :ampm => amPm
    };
}


/**
 * This service delegate runs in the background and asks an app on the mobile
 * phone for the next calendar appointment.
 */
(:background)
class CalendarServiceDelegate extends System.ServiceDelegate {

    function initialize() {
        System.ServiceDelegate.initialize();
    }

    function onTemporalEvent() {
        // Check if Bluetooth is currently enabled. If not, there is no use trying to
        // communicate with the phone
        if (!System.getDeviceSettings().phoneConnected) {
            Background.exit(null);
        }

        // Register for phone messages and send a request
        Communications.registerForPhoneAppMessages(method(:phoneMessageReceived));
        Communications.transmit(
            NEXT_APPOINTMENT_REQUEST,
            {},
            new CalendarConnectionListener());

        /* Code stub that simply returns an appointment time of one hour from now.
        var utcNow = Time.now().value() - UTC_OFFSET;
        var utcInAnHour = new Time.Moment(utcNow).add(new Time.Duration(3600)).value();
        Background.exit({
            CALENDAR_SERVICE_KEY => CALENDAR_SERVICE_ID,
            NEXT_APPOINTMENT_KEY => utcInAnHour});
        */
    }

    function phoneMessageReceived(message) {
        System.println("Received: " + message.data);
        Background.exit({
            CALENDAR_SERVICE_KEY => CALENDAR_SERVICE_ID,
            NEXT_APPOINTMENT_KEY => message.data});
    }

}

/**
 * Listens for success or error when sending messages to the phone.
 */
(:background)
class CalendarConnectionListener extends Communications.ConnectionListener {

    function initialize() {
        Communications.ConnectionListener.initialize();
    }

    function onComplete() {
        // There's not really anything to do here but allow the background service
        // to continue running and waiting for the phone app to respond to its
        // request
    }

    function onError() {
        // Sending the request failed -- no need for the background service to
        // continue running...
        Background.exit(null);
    }

}
