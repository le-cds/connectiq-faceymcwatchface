using Toybox.System;

/**
 * Indicator for the watch's battery state. Does not support partial updates
 * since updating the battery state once per minute is enough.
 */
class IndicatorBehaviorBattery extends DefaultIndicatorBehavior {

    // I wasn't able to find out how (and if) character arithmetic works, so this
    // array is a workaround
    private const SYMBOL_BATTERY = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":"];
    
    public function initialize() {
        DefaultIndicatorBehavior.initialize(false);
    }
    
    public function isIndicating() {
        // The indicator should light up if the battery level has dropped below 20%
        return System.getSystemStats().battery < 20;
    }
    
    public function getIconCharacter() {
        // Compute in which battery percentile we are (unless we're currently charging):
        //    0% to 10% -> 0
        //   11% to 20% -> 1
        //   ...
        var stats = System.getSystemStats();
        var batt = stats.battery.toNumber();

        var battSymbol = 10;
        if (!stats.charging) {
            battSymbol = (batt - 1) / 10;
            if (battSymbol < 0) {
                battSymbol = 0;
            }
        }
        
        // To the Batt Mobile, Robin!
        return SYMBOL_BATTERY[battSymbol];
    }
    
    public function getValue() {
        return System.getSystemStats().battery.format("%d") + "%";
    }
    
}