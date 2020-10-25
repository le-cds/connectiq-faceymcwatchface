using Toybox.System;

/**
 * Indicator for today's burned calories. Does not support partial updates.
 */
class IndicatorBehaviorCalories extends DefaultIndicatorBehavior {
    
    private var mCalories = 0;

    public function initialize() {
        DefaultIndicatorBehavior.initialize(false);
    }
    
    public function update() {
        var info = ActivityMonitor.getInfo();
        
        if (info has :calories) {
            mCalories = info.calories;
            
            if (mCalories == null) {
                mCalories = 0;
            }
        }
    }
    
    public function isIndicating() {
        // There is no calory goal or anything like that
        return false;
    }
    
    public function getIconCharacter() {
        return "M";
    }
    
    public function getValue() {
        return toShortNumberString(mCalories);
    }
    
}