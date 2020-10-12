using Toybox.System;

/**
 * Implements behavior for displaying the battery state.
 */
class BatteryMeterBehavior extends MeterBehavior {

    function initialize() {
        MeterBehavior.initialize();
    }
    
    public function getIconFont() {
        return gSymbolsFont;
    }
    
    public function getIconColor() {
        // Light up if the battery charge falls below 20%
        if (System.getSystemStats().battery < 20) {
            return gColorIndicatorActive;
        } else {
            return gColorIndicatorInactive;
        }
    }
    
    public function getBackgroundColor() {
        return gColorBackground;
    }
    
    public function getIconCharacter() {
        if (System.getSystemStats().charging) {
            return ":";
        } else {
            return "9";
        }
    }
    
    public function getCurrValue() {
        return System.getSystemStats().battery.toNumber();
    }
    
    public function getMaxValue() {
        return 100;
    }
    
    public function getActiveMeterColor() {
        return gColorHighlights;
    }
    
    public function getInactiveMeterColor() {
        return gColorMeterBackground;
    }
    
}