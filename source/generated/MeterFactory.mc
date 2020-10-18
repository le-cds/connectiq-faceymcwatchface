/**
 * Turns a behavior ID into an instance of the class that implements the behavior.
 */
function createMeterBehavior(id){
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
    }
}
