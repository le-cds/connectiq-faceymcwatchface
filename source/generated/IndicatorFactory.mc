using FaceyIndicatorConstants as FC;

/**
 * Turns a behavior ID into an instance of the class that implements the behavior.
 */
function createIndicatorBehavior(id){
    switch (id) {
        case FC.INDICATOR_BEHAVIOR_ALARMS:
            return new IndicatorBehaviorAlarms();
        case FC.INDICATOR_BEHAVIOR_APPOINTMENTS:
            return new IndicatorBehaviorAppointments();
        case FC.INDICATOR_BEHAVIOR_BATTERY:
            return new IndicatorBehaviorBattery();
        case FC.INDICATOR_BEHAVIOR_BLUETOOTH:
            return new IndicatorBehaviorBluetooth();
        case FC.INDICATOR_BEHAVIOR_DND:
            return new IndicatorBehaviorDND();
        case FC.INDICATOR_BEHAVIOR_HEART_RATE:
            return new IndicatorBehaviorHeartRate();
        case FC.INDICATOR_BEHAVIOR_NOTIFICATIONS:
            return new IndicatorBehaviorNotifications();
    }
}
