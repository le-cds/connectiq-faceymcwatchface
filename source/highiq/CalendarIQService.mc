using Toybox.Application;
using Toybox.Background;
using Toybox.Communications;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;

/* This file provides all of the code necessary to receive and parse messages from
 * the CalendarIQ app. To use it, the application must have the background and
 * communication permissions set in its manifest.
 *
 *
 * Setup
 *
 * - In your AppBase subclass, call registerCalendarService() in the getInitialView()
 *   function or register for temporal events yourself. Optionally, call the
 *   loadCalendarIQData() function as well. If you don't it will be called automatically
 *   upon the first invocation to getNextAppointment().
 *
 * - Add a getServiceDelegate() function and return a list that contains an instance
 *   of CalendarServiceDelegate.
 *
 * - Add an onBackgroundData(data) function and call processCalendarIQServiceData(data).
 *   If the function returns true, the data came from the calendar service. If not,
 *   they may have come from other delegates that you're in charge of processing some
 *   other way.
 *
 * - Add a call to storeCalendarIQData() to your onStop() function so that when the
 *   app is closed, we store the state of our appointments. To save energy, this
 *   library avoids any access to storage while the app is running.
 *
 *
 * Data Retrieval
 *
 * - To retrieve the next appointment, call getNextAppointment(). The method will
 *   return null if we have no information about a next appointment, or a Time.Moment
 *   instance otherwise.
 *
 * - Use the displayable...(...) methods to turn an appointment into a dictionary of
 *   time components that can be displayed on screen.
 * 
 * - To retrieve the phone's most recently known battery level, call getPhoneBatteryLevel().
 */


///////////////////////////////////////////////////////////////////////////////////////////////////
// CONSTANTS

/**
 * UTC time zone offset. Subtract from local time to get UTC time, add to
 * UTC time to get local time.
 */
const UTC_OFFSET = System.getClockTime().timeZoneOffset;

/** Identifier of the calendar service. */
const CALENDAR_IQ_SERVICE_ID = "calendarservice";

/** Property key under which the time of the most recent update is stored. */
const KEY_LAST_REFRESH = CALENDAR_IQ_SERVICE_ID + ".lastupdatetime";
/** Property key under which the number of saved next appointments is stored. */
const KEY_APPOINTMENT_COUNT = CALENDAR_IQ_SERVICE_ID + ".appointmentcount";
/** Property key under which the appointment data are stored. */
const KEY_APPOINTMENTS = CALENDAR_IQ_SERVICE_ID + ".appointments";
/** Property key under which the phone battery level is stored. */
const KEY_PHONE_BATTERY = CALENDAR_IQ_SERVICE_ID + ".phonebattery";


///////////////////////////////////////////////////////////////////////////////////////////////////
// STATE

/* The following variables store appointment data in main memory to spare us the
 * need of having to load the values from storage each minute, which costs time
 * and energy. The values are put into storage whenever the background service
 * finishes.
 */

/** The appointment interval in seconds. Overwritten as soon as the calendar service is registered. */
var update_interval = 15 * 60;
/** Time of when we most recently received appointment data. */
var last_refresh = -1;
/** The number of appointments. */
var appointment_count = -1;
/** Array of appointments. */
var appointments = null;
/** The phone battery level, if available. */
var phone_battery_level = null;


///////////////////////////////////////////////////////////////////////////////////////////////////
// SETUP

/**
 * Checks whether or not the calendar service can be run on this device.
 */
function hasCalendarIQService() {
    return System has :ServiceDelegate;
}

/**
 * Tries to register a background process for the calendar processing. This
 * will succeed if the watch supports service delegates. Call this procedure from
 * the base app's getInitialView() function.
 *
 * @param update_interval the number of minutes between successive updates.
 * @return true or false as the registration did or did not complete successfully.
 */
function registerCalendarIQService(the_update_interval) {
    if (hasCalendarIQService()) {
        // Run the service every updateInterval minutes
        update_interval = the_update_interval * 60;
        Background.registerForTemporalEvent(new Time.Duration(update_interval));
        return true;
    } else {
        return false;
    }
}

/**
 * Unregisters the background process for the calendar processing.
 */
function unregisterCalendarIQService() {
    // Stops the calendar service
    if (hasCalendarIQService()) {
        Background.deleteTemporalEvent();
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// SERVICE INTERFACE

/**
 * Processes the calendar service data if they come from the calendar service
 * in the first place. If not, we take the opportunity to sanitize the appointment
 * data we have saved by removing those appointments that are now in the past.
 *
 * @return true if the data came from the calendar service and were processed
 *         by this method, false if the data should be further processed by
 *         the caller.
 */
function processCalendarIQServiceData(data) {
    if (data instanceof Lang.Dictionary && CALENDAR_IQ_SERVICE_ID.equals(data[CALENDAR_IQ_SERVICE_ID])) {
        // Save the appointments in our local variables to be saved later
        last_refresh = Time.now().value();
        appointment_count = data[KEY_APPOINTMENT_COUNT];
        appointments = data[KEY_APPOINTMENTS];
        phone_battery_level = data[KEY_PHONE_BATTERY];

        return true;

    } else {
        sanitizeCalendarIQData();
        return false;
    }

}

/**
 * Sanitizes the saved data by removing appointments that are now in the past.
 */
function sanitizeCalendarIQData() {
    if (appointments != null && appointment_count > 0) {
        // Get the current time in seconds UTC
        var now = Time.now().value();
    
        // Go through the list of appointments and find the index of the first which is still
        // in the future
        var firstValidIndex = 0;
        while (firstValidIndex < appointment_count && appointments[firstValidIndex] <= now) {
            firstValidIndex += 1;
        }
    
        // If we have moved past passed appointments, save the new list
        if (firstValidIndex > 0) {
            if (firstValidIndex >= appointment_count) {
                // Reset our variables
                appointment_count = 0;
                appointments = null;
    
            } else {
                // Build a new array
                var newAppointments = new [appointment_count - firstValidIndex];
                for (var i = firstValidIndex; i < appointment_count; i++) {
                    newAppointments[i - firstValidIndex] = appointments[i];
                }
    
                // Update the variables
                appointment_count -= firstValidIndex;
                appointments = newAppointments;
            }
        }
    }
}

/**
 * Loads all data from storage. This is automatically called by the getNextAppointment()
 * function if it hasn't been called before, but can also be called manually.
 */
function loadCalendarIQData() {
    last_refresh = Application.Storage.getValue(KEY_LAST_REFRESH);
    appointment_count = Application.Storage.getValue(KEY_APPOINTMENT_COUNT);
    appointments = Application.Storage.getValue(KEY_APPOINTMENTS);
    phone_battery_level = Application.Storage.getValue(KEY_PHONE_BATTERY);

    // If the appointment count is not existent, set it to zero to make sure that
    // getNextAppointment() doesn't call loadCalendarIQData() on every invocation
    if (appointment_count == null || appointment_count < 0) {
        appointment_count = 0;
    }
}

/**
 * Saves our appointment variables to storage to be retrieved later.
 */
function storeCalendarIQData() {
    Application.Storage.setValue(KEY_LAST_REFRESH, last_refresh);
    Application.Storage.setValue(KEY_APPOINTMENT_COUNT, appointment_count);
    Application.Storage.setValue(KEY_APPOINTMENTS, appointments);
    Application.Storage.setValue(KEY_PHONE_BATTERY, phone_battery_level);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// DATA ACCESS

/**
 * Returns the last known phone battery level. This value is between 0 and 100 if the
 * phone is not charging, and between 0 and -100 if it is. The absolute value always
 * indicates the battery charge. If the battery level is unknown, return null.
 */
function getPhoneBatteryLevel() {
    return phone_battery_level;
}

/**
 * Returns a Moment that specifies the time of the next appointment in local time. The
 * moment is only returned if it is in the upcoming 24 hours. If not, null is returned.
 */
function getNextAppointment() {
    if (appointment_count == -1) {
        // We haven't loaded appointments yet, so try loading them and proceed
        loadCalendarIQData();
    }

    // If we don't have any appointments, return nothing.
    if (appointments == null || appointment_count == 0) {
        return null;
    }

    // Get the current time in seconds UTC
    var now = Time.now().value();

    // Go through the list of appointments and find the index of the first which is still
    // in the future
    var firstValidIndex = 0;
    while (firstValidIndex < appointment_count && appointments[firstValidIndex] <= now) {
        firstValidIndex += 1;
    }

    if (firstValidIndex < appointment_count) {
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


///////////////////////////////////////////////////////////////////////////////////////////////////
// UTILITIES

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


///////////////////////////////////////////////////////////////////////////////////////////////////
// SERVICE DELEGATE

/**
 * This service delegate runs in the background and asks an app on the mobile
 * phone for the next calendar appointment.
 */
(:background)
class CalendarIQServiceDelegate extends System.ServiceDelegate {

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
            KEY_CALENDAR_IQ_SERVICE => CALENDAR_IQ_SERVICE_ID,
            KEY_APPOINTMENT_COUNT => appointmentCount,
            KEY_APPOINTMENTS => appointments});
        */
    }

    function phoneMessageReceived(message) {
        // Only end the background process by handling this message if it was sent
        // after our most recent invocation
        var messageTimestamp = message.data[0];
        var lastInvocation = Time.now().value() - update_interval;

        if (messageTimestamp >= lastInvocation) {
            // Unpack appointments
            var appointmentCount = message.data[1];

            var appointments = new [appointmentCount];
            for (var i = 0; i < appointmentCount; i += 1) {
                // Discard any superfluous seconds; minute granularity is perfectly fine
                appointments[i] = message.data[i + 2] - message.data[i + 2] % 60;
            }
            
            // See if there's more data following. See CalendarIQ message format docs. The
            // Index pointer here points at the first unused array element.
            var msgIdx = 2 + appointmentCount;
            
            // Check for phone sync interval setting
            if (msgIdx < message.data.size()) {
                // Not used yet
            }
            
            // Advance and check for phone battery state
            msgIdx++;
            var phoneBattery = null;
            if (msgIdx < message.data.size()) {
                phoneBattery = message.data[msgIdx];
            }

            Background.exit({
                CALENDAR_IQ_SERVICE_ID => CALENDAR_IQ_SERVICE_ID,
                KEY_APPOINTMENT_COUNT => appointmentCount,
                KEY_APPOINTMENTS => appointments,
                KEY_PHONE_BATTERY => phoneBattery});
        }
    }

}
