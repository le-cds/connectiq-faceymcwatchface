/**
 * Turns a behavior ID into an instance of the class that implements the behavior.
 */
function createIndicatorBehavior(id){
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
    }
}
