
// Enumeration of all available indicator behaviors. New behaviors must be
// appended to ensure that existing ones don't get new numbers assigned to
// them.
enum /* INDICATOR_BEHAVIORS */ {
    INDICATOR_ALARMS,
    INDICATOR_APPOINTMENTS,
    INDICATOR_BATTERY,
    INDICATOR_BLUETOOTH,
    INDICATOR_DND,
    INDICATOR_HEART_RATE,
    INDICATOR_NOTIFICATIONS
}

/**
 * Returns an indicator behavior instance that corresponds to the given ID.
 * IDs are defined by the enumeration above.
 */
function createIndicatorBehavior(id) {
    switch (id) {
        case INDICATOR_ALARMS:
            return new AlarmsIndicatorBehavior();
        case INDICATOR_APPOINTMENTS:
            return new AppointmentIndicatorBehavior();
        case INDICATOR_BATTERY:
            return new BatteryIndicatorBehavior();
        case INDICATOR_BLUETOOTH:
            return new BluetoothIndicatorBehavior();
        case INDICATOR_DND:
            return new DoNotDisturbIndicatorBehavior();
        case INDICATOR_HEART_RATE:
            return new HeartRateIndicatorBehavior();
        case INDICATOR_NOTIFICATIONS:
            return new NotificationsIndicatorBehavior();
        default:
            return null;
    }
}

// Enumeration of all available meter behaviors. New behaviors must be
// appended to ensure that existing ones don't get new numbers assigned
// to them.
enum /* METER_BEHAVIORS */ {
    METER_BATTERY,
    METER_STAIRS,
    METER_STEPS
}

/**
 * Returns a meter behavior instance that corresponds to the given ID.
 * IDs are defined by the enumeration above.
 */
function createMeterBehavior(id) {
    switch (id) {
        case METER_BATTERY:
            return new BatteryMeterBehavior();
        case METER_STAIRS:
            return new StairsMeterBehavior();
        case METER_STEPS:
            return new StepsMeterBehavior();
        default:
            return null;
    }
}
