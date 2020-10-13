/**
 * Implements behavior for displaying the number of steps.
 */
class StairsMeterBehavior extends DefaultMeterBehavior {
    
    // Cache most recent values
    private var mStairs = 0;
    private var mStairsGoal = 1;

    function initialize() {
        DefaultMeterBehavior.initialize();
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
    
    public function isIndicating() {
        // Light up if the steps goal has been reached
        return mStairs >= mStairsGoal;
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
    
}