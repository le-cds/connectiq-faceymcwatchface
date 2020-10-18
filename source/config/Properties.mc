/* Defines property keys. */

const APPOINTMENT_UPDATE_INTERVAL = "AppointmentUpdateInterval";

///////////////////////////////////////////////////////////////////////////////////
// Indicators

const INDICATOR_COUNT = 6;

enum /* INDICATORS */ {
    INDICATOR_TOP_LEFT,
    INDICATOR_TOP_RIGHT,
    INDICATOR_CENTER,
    INDICATOR_BOTTOM_LEFT,
    INDICATOR_BOTTOM_CENTER,
    INDICATOR_BOTTOM_RIGHT
}

const INDICATOR_NAMES = [
    "IndicatorTopLeft",
    "IndicatorTopRight",
    "IndicatorCenter",
    "IndicatorBottomLeft",
    "IndicatorBottomCenter",
    "IndicatorBottomRight"
];

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

const INDICATOR_BEHAVIOR_NAMES = [
    "IndicatorAlarms",
    "IndicatorAppointments",
    "IndicatorBattery",
    "IndicatorBluetooth",
    "IndicatorDnD",
    "IndicatorHeartRate",
    "IndicatorNotifications"
];

///////////////////////////////////////////////////////////////////////////////////
// Meters

const METER_COUNT = 2;

enum /* METERS */ {
    METER_LEFT,
    METER_RIGHT
}

const METER_NAMES = [
    "MeterLeft",
    "MeterRight"
];

// Enumeration of all available meter behaviors. New behaviors must be
// appended to ensure that existing ones don't get new numbers assigned
// to them.
enum /* METER_BEHAVIORS */ {
    METER_BATTERY,
    METER_FLOORS_CLIMBED,
    METER_STEPS,
    METER_MOVE_BAR,
    METER_ACTIVE_MINUTES
}

const METER_BEHAVIOR_NAMES = [
    "MeterBattery",
    "MeterFloorsClimbed",
    "MeterSteps",
    "MeterMoveBar",
    "MeterActiveMinutes"
];
