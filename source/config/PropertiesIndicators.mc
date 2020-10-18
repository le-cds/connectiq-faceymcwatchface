/* Defines property keys. */

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
