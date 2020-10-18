/* Defines property keys. */

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
