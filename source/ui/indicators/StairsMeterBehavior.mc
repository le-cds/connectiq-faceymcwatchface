/**
 * Implements behavior for displaying the number of steps.
 */
class StairsMeterBehavior extends MeterBehavior {
    
    // Cache most recent values
    private var mStairs = 0;
    private var mStairsGoal = 1;

    function initialize() {
        MeterBehavior.initialize();
    }
    
    public function update() {
        var info = ActivityMonitor.getInfo();
        
        if (info has :floorsClimbed) {
            mStairs = info.floorsClimbed;
            mStairsGoal = info.floorsClimbedGoal;
            
            if (mStairsGoal < 1) {
                mStairsGoal = 1;
            }
        }
    }
    
    public function getIconFont() {
        return gSymbolsFont;
    }
    
    public function getIconColor() {
        // Light up if the steps goal has been reached
        if (mStairs >= mStairsGoal) {
            return gColorIndicatorActive;
        } else {
            return gColorIndicatorInactive;
        }
    }
    
    public function getBackgroundColor() {
        return gColorBackground;
    }
    
    public function getIconCharacter() {
        return 'F';
    }
    
    public function getCurrValue() {
        return mStairs;
    }
    
    public function getMaxValue() {
        return mStairsGoal;
    }
    
    public function getActiveMeterColor() {
        return gColorHighlights;
    }
    
    public function getInactiveMeterColor() {
        return gColorMeterBackground;
    }
    
}