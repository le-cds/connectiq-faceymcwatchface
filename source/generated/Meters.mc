// This is a generated file. Do not edit manually or suffer the consequences...

module FaceyMcWatchface {
module Meters {

// Number of things and behaviors
const METER_COUNT = 2;
const METER_BEHAVIOR_COUNT = 6;

// Enumerations of available things and behaviors to index into the other arrays
enum /* METER */ {
    METER_LEFT,
    METER_RIGHT
}

enum /* METER_BEHAVIORS */ {
    METER_BEHAVIOR_BATTERY,
    METER_BEHAVIOR_FLOORS_CLIMBED,
    METER_BEHAVIOR_STEPS,
    METER_BEHAVIOR_MOVE_BAR,
    METER_BEHAVIOR_ACTIVE_MINUTES,
    METER_BEHAVIOR_PHONE_BATTERY
}

// Names used in all sorts of properties, settings, drawables...
const METER_NAMES = [
    "MeterLeft",
    "MeterRight"
];

const METER_BEHAVIOR_NAMES = [
    "MeterBehaviorBattery",
    "MeterBehaviorFloorsClimbed",
    "MeterBehaviorSteps",
    "MeterBehaviorMoveBar",
    "MeterBehaviorActiveMinutes",
    "MeterBehaviorPhoneBattery"
];

// String resource IDs that belong to things. Use these to generate names in the UI.
const METER_TO_STRING_RESOURCE = [
    Rez.Strings.MeterLeft,
    Rez.Strings.MeterRight
];

const METER_BEHAVIOR_TO_STRING_RESOURCE = [
    Rez.Strings.MeterBehaviorBattery,
    Rez.Strings.MeterBehaviorFloorsClimbed,
    Rez.Strings.MeterBehaviorSteps,
    Rez.Strings.MeterBehaviorMoveBar,
    Rez.Strings.MeterBehaviorActiveMinutes,
    Rez.Strings.MeterBehaviorPhoneBattery
];

/**
 * Turns a behavior ID into an instance of the class that implements the behavior.
 */
function createMeterBehavior(id) {
    switch (id) {
        case METER_BEHAVIOR_BATTERY:
            return new MeterBehaviorBattery();
        case METER_BEHAVIOR_FLOORS_CLIMBED:
            return new MeterBehaviorFloorsClimbed();
        case METER_BEHAVIOR_STEPS:
            return new MeterBehaviorSteps();
        case METER_BEHAVIOR_MOVE_BAR:
            return new MeterBehaviorMoveBar();
        case METER_BEHAVIOR_ACTIVE_MINUTES:
            return new MeterBehaviorActiveMinutes();
        case METER_BEHAVIOR_PHONE_BATTERY:
            return new MeterBehaviorPhoneBattery();
        default:
            return null;
    }
}

} }
