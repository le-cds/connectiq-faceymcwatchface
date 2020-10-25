// This is a generated file. Do not edit manually or suffer the consequences...

module FaceyMcWatchface {
module Indicators {

// Number of things and behaviors
const INDICATOR_COUNT = 6;
const INDICATOR_BEHAVIOR_COUNT = 12;

// Enumerations of available things and behaviors to index into the other arrays
enum /* INDICATOR */ {
    INDICATOR_TOP_LEFT,
    INDICATOR_TOP_RIGHT,
    INDICATOR_CENTER,
    INDICATOR_BOTTOM_LEFT,
    INDICATOR_BOTTOM_CENTER,
    INDICATOR_BOTTOM_RIGHT
}

enum /* INDICATOR_BEHAVIORS */ {
    INDICATOR_BEHAVIOR_ALARMS,
    INDICATOR_BEHAVIOR_APPOINTMENTS,
    INDICATOR_BEHAVIOR_BATTERY,
    INDICATOR_BEHAVIOR_BLUETOOTH,
    INDICATOR_BEHAVIOR_DND,
    INDICATOR_BEHAVIOR_HEART_RATE,
    INDICATOR_BEHAVIOR_NOTIFICATIONS,
    INDICATOR_BEHAVIOR_STEPS,
    INDICATOR_BEHAVIOR_FLOORS_CLIMBED,
    INDICATOR_BEHAVIOR_FLOORS_DESCENDED,
    INDICATOR_BEHAVIOR_CALORIES,
    INDICATOR_BEHAVIOR_ALTITUDE
}

// Names used in all sorts of properties, settings, drawables...
const INDICATOR_NAMES = [
    "IndicatorTopLeft",
    "IndicatorTopRight",
    "IndicatorCenter",
    "IndicatorBottomLeft",
    "IndicatorBottomCenter",
    "IndicatorBottomRight"
];

const INDICATOR_BEHAVIOR_NAMES = [
    "IndicatorBehaviorAlarms",
    "IndicatorBehaviorAppointments",
    "IndicatorBehaviorBattery",
    "IndicatorBehaviorBluetooth",
    "IndicatorBehaviorDND",
    "IndicatorBehaviorHeartRate",
    "IndicatorBehaviorNotifications",
    "IndicatorBehaviorSteps",
    "IndicatorBehaviorFloorsClimbed",
    "IndicatorBehaviorFloorsDescended",
    "IndicatorBehaviorCalories",
    "IndicatorBehaviorAltitude"
];

// String resource IDs that belong to things. Use these to generate names in the UI.
const INDICATOR_TO_STRING_RESOURCE = [
    Rez.Strings.IndicatorTopLeft,
    Rez.Strings.IndicatorTopRight,
    Rez.Strings.IndicatorCenter,
    Rez.Strings.IndicatorBottomLeft,
    Rez.Strings.IndicatorBottomCenter,
    Rez.Strings.IndicatorBottomRight
];

const INDICATOR_BEHAVIOR_TO_STRING_RESOURCE = [
    Rez.Strings.IndicatorBehaviorAlarms,
    Rez.Strings.IndicatorBehaviorAppointments,
    Rez.Strings.IndicatorBehaviorBattery,
    Rez.Strings.IndicatorBehaviorBluetooth,
    Rez.Strings.IndicatorBehaviorDND,
    Rez.Strings.IndicatorBehaviorHeartRate,
    Rez.Strings.IndicatorBehaviorNotifications,
    Rez.Strings.IndicatorBehaviorSteps,
    Rez.Strings.IndicatorBehaviorFloorsClimbed,
    Rez.Strings.IndicatorBehaviorFloorsDescended,
    Rez.Strings.IndicatorBehaviorCalories,
    Rez.Strings.IndicatorBehaviorAltitude
];

/**
 * Turns a behavior ID into an instance of the class that implements the behavior.
 */
function createIndicatorBehavior(id) {
    switch (id) {
        case INDICATOR_BEHAVIOR_ALARMS:
            return new IndicatorBehaviorAlarms();
        case INDICATOR_BEHAVIOR_APPOINTMENTS:
            return new IndicatorBehaviorAppointments();
        case INDICATOR_BEHAVIOR_BATTERY:
            return new IndicatorBehaviorBattery();
        case INDICATOR_BEHAVIOR_BLUETOOTH:
            return new IndicatorBehaviorBluetooth();
        case INDICATOR_BEHAVIOR_DND:
            return new IndicatorBehaviorDND();
        case INDICATOR_BEHAVIOR_HEART_RATE:
            return new IndicatorBehaviorHeartRate();
        case INDICATOR_BEHAVIOR_NOTIFICATIONS:
            return new IndicatorBehaviorNotifications();
        case INDICATOR_BEHAVIOR_STEPS:
            return new IndicatorBehaviorSteps();
        case INDICATOR_BEHAVIOR_FLOORS_CLIMBED:
            return new IndicatorBehaviorFloorsClimbed();
        case INDICATOR_BEHAVIOR_FLOORS_DESCENDED:
            return new IndicatorBehaviorFloorsDescended();
        case INDICATOR_BEHAVIOR_CALORIES:
            return new IndicatorBehaviorCalories();
        case INDICATOR_BEHAVIOR_ALTITUDE:
            return new IndicatorBehaviorAltitude();
    }
}

} }
