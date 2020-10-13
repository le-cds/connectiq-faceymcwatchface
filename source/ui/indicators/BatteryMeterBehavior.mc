using Toybox.System;

/**
 * Implements behavior for displaying the battery state.
 */
class BatteryMeterBehavior extends DefaultMeterBehavior {

    function initialize() {
        DefaultMeterBehavior.initialize();
    }
    
    public function isIndicating() {
        // Light up if the battery charge falls below 20%
        return System.getSystemStats().battery < 20;
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
    
}