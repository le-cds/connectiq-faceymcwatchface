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

/** Number of seconds between consecutive invocations of the background process. */
const INVOCATION_INTERVAL = 900;

/**
 * UTC time zone offset. Subtract from local time to get UTC time, add to
 * UTC time to get local time.
 */
const UTC_OFFSET = System.getClockTime().timeZoneOffset;

/** Identifier of the calendar service. */
const CALENDAR_SERVICE_ID = "calendarservice";

/** Property key under which the time of the most recent update is stored. */
const PROP_LAST_REFRESH = CALENDAR_SERVICE_ID + ".lastupdatetime";
/** Property key under which the number of saved next appointments is stored. */
const PROP_APPOINTMENT_COUNT = CALENDAR_SERVICE_ID + ".appointmentcount";
/** Property key under which the next appointment data are stored. */
const PROP_APPOINTMENTS = CALENDAR_SERVICE_ID + ".appointments";

/** Dictionary key to identify this service as being the source of a background job result. */
const KEY_CALENDAR_SERVICE = "service";
/** Dictionary key under which the number of appointments will be stored. */
const KEY_APPOINTMENT_COUNT = "appointmentcount";
/** Dictionary key under which the next appointment times will be stored. */
const KEY_APPOINTMENTS = "appointments";


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
        Background.registerForTemporalEvent(new Time.Duration(INVOCATION_INTERVAL));
        return true;
    } else {
        return false;
    }
}

/**
 * Processes the calendar service data if they come from the calendar service
 * in the first place. If not, we sanitize the appointment data we have saved
 * by removing those appointments that are now in the past.
 *
 * @return true if the data came from the calendar service and were processed
 *         by this method, false if the data should be further processed by
 *         the caller.
 */
function processCalendarServiceData(data) {
    if (data instanceof Lang.Dictionary && CALENDAR_SERVICE_ID.equals(data[KEY_CALENDAR_SERVICE])) {
        // Save the appointments
        Application.Storage.setValue(PROP_LAST_REFRESH, Time.now().value());
        Application.Storage.setValue(PROP_APPOINTMENT_COUNT, data[KEY_APPOINTMENT_COUNT]);
        Application.Storage.setValue(PROP_APPOINTMENTS, data[KEY_APPOINTMENTS]);

        return true;

    } else {
        // If we don't have any appointments yet, return nothing.
        var appointmentCount = Application.Storage.getValue(PROP_APPOINTMENT_COUNT);
        var appointments = Application.Storage.getValue(PROP_APPOINTMENTS);
        if (appointments == null || appointmentCount == null || appointmentCount == 0) {
            return false;
        }

        // Get the current time in seconds UTC
        var now = Time.now().value();

        // Go through the list of appointments and find the index of the first which is still
        // in the future
        var firstValidIndex = 0;
        while (firstValidIndex < appointmentCount && appointments[firstValidIndex] <= now) {
            firstValidIndex += 1;
        }

        // If we have moved past passed appointments, save the new list
        if (firstValidIndex > 0) {
            if (firstValidIndex >= appointmentCount) {
                // Reset our variables
                appointmentCount = 0;
                appointments = null;

            } else {
                // Build a new array
                var newAppointments = new [appointmentCount - firstValidIndex];
                for (var i = firstValidIndex; i < appointmentCount; i++) {
                    newAppointments[i - firstValidIndex] = appointments[i];
                }

                // Update the variables
                appointmentCount -= firstValidIndex;
                appointments = newAppointments;
            }

            // Save the new stuff
            Application.Storage.setValue(PROP_APPOINTMENT_COUNT, appointmentCount);
            Application.Storage.setValue(PROP_APPOINTMENTS, appointments);
        }

        return false;
    }
}

/**
 * Returns a Moment that specifies the time of the next appointment in local time. The
 * moment is only returned if it is in the upcoming 24 hours. If not, null is returned.
 */
function getNextAppointment() {
    // If we don't have any appointments yet, return nothing.
    var appointmentCount = Application.Storage.getValue(PROP_APPOINTMENT_COUNT);
    var appointments = Application.Storage.getValue(PROP_APPOINTMENTS);
    if (appointments == null || appointmentCount == null || appointmentCount == 0) {
        return null;
    }

    // Get the current time in seconds UTC
    var now = Time.now().value();

    // Go through the list of appointments and find the index of the first which is still
    // in the future
    var firstValidIndex = 0;
    while (firstValidIndex < appointmentCount && appointments[firstValidIndex] <= now) {
        firstValidIndex += 1;
    }

    if (firstValidIndex < appointmentCount) {
        var nextAppointment = appointments[firstValidIndex];

        // We have an appointment in UTC time. Return it if it is in the upcoming 24 hours
        // minus 5 minutes
        var nextAppointmentMoment = new Time.Moment(nextAppointment);
        var nowMoment = new Time.Moment(now);
        var dayFromNowMoment = nowMoment.add(new Time.Duration(Time.Gregorian.SECONDS_PER_DAY - 300));

        if (nextAppointmentMoment.greaterThan(nowMoment) && nextAppointmentMoment.lessThan(dayFromNowMoment)) {
            return nextAppointmentMoment;
        }
    }

    return null;
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

        // Register for phone messages and hope that we have received one
        Communications.registerForPhoneAppMessages(method(:phoneMessageReceived));

        /*
        // Code stub that simply returns a number of appointments in two-minute intervals,
        // starting three minutes in the past to check whether our code correctly sorts those out
        var appointmentCount = 10;
        var appointments = new [appointmentCount];

        var app = new Time.Moment(Time.now().value() - 3 * 60);
        var interval = new Time.Duration(2 * 60);
        for (var i = 0; i < appointmentCount; i++) {
            appointments[i] = app.value() - app.value() % 60;
            app = app.add(interval);
        }

        Background.exit({
            KEY_CALENDAR_SERVICE => CALENDAR_SERVICE_ID,
            KEY_APPOINTMENT_COUNT => appointmentCount,
            KEY_APPOINTMENTS => appointments});
        */
    }

    function phoneMessageReceived(message) {
        // Only end the background process by handling this message if it was sent
        // after our most recent invocation
        var messageTimestamp = message.data[0];
        var lastInvocation = Time.now().value() - INVOCATION_INTERVAL;

        if (messageTimestamp >= lastInvocation) {
            // Unpack the remainder of the message
            var appointmentCount = message.data[1];

            var appointments = new [appointmentCount];
            for (var i = 0; i < appointmentCount; i += 1) {
                // Discard any superfluous seconds; minute granularity is perfectly fine
                appointments[i] = message.data[i + 2] - message.data[i + 2] % 60;
            }

            Background.exit({
                KEY_CALENDAR_SERVICE => CALENDAR_SERVICE_ID,
                KEY_APPOINTMENT_COUNT => appointmentCount,
                KEY_APPOINTMENTS => appointments});
        }
    }

}
