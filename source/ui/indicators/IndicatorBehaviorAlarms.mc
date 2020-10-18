using Toybox.System;

/**
 * Indicator for the watch's active alarms. Does not support partial updates
 * since if the number of alarms changes, the watchface will be redrawn anyway.
 */
class IndicatorBehaviorAlarms extends DefaultIndicatorBehavior {

    public function initialize() {
        DefaultIndicatorBehavior.initialize(false);
    }
    
    public function isIndicating() {
        // The indicator should light up if there are active alarms
        return System.getDeviceSettings().alarmCount > 0;
    }
    
    public function getIconCharacter() {
        return "D";
    }
    
    public function getValue() {
        return System.getDeviceSettings().alarmCount.format("%d");
    }
    
}