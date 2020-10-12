using Toybox.System;

/**
 * Indicator for the watch's active alarms. Does not support partial updates
 * since if the number of alarms changes, the watchface will be redrawn anyway.
 */
class AlarmsBehavior extends ValueBehavior {

    public function initialize() {
        ValueBehavior.initialize(false);
    }
    
    public function getIconFont() {
        return gSymbolsFont;
    }
    
    public function getIconColor() {
        // The indicator should light up if there are active alarms
        if (System.getDeviceSettings().alarmCount > 0) {
            return gColorIndicatorActive;
        } else {
            return gColorIndicatorInactive;
        }
    }
    
    public function getBackgroundColor() {
        return gColorBackground;
    }
    
    public function getIconCharacter() {
        return "D";
    }
    
    public function getValueFont() {
        return gIndicatorFont;
    }
    
    public function getValueColor() {
        return gColorIndicatorText;
    }
    
    public function getValue() {
        return System.getDeviceSettings().alarmCount.format("%d");
    }
    
}