/**
 * Implements behavior for displaying the number of steps.
 */
class MeterBehaviorSteps extends DefaultMeterBehavior {
    
    // Cache most recent values
    private var mSteps = 0;
    private var mStepsGoal = 1;

    function initialize() {
        DefaultMeterBehavior.initialize();
    }
    
    public function update() {
        var info = ActivityMonitor.getInfo();
        mSteps = info.steps;
        mStepsGoal = info.stepGoal;
        
        if (mStepsGoal < 1) {
            mStepsGoal = 1;
        }
    }
    
    public function isIndicating() {
        // Light up if the steps goal has been reached
        return mSteps >= mStepsGoal;
    }
    
    public function getIconCharacter() {
        return 'E';
    }
    
    public function getCurrValue() {
        return mSteps;
    }
    
    public function getMaxValue() {
        return mStepsGoal;
    }
    
}