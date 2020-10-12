/**
 * Implements behavior for displaying the number of steps.
 */
class StepsMeterBehavior extends MeterBehavior {
    
    // Cache most recent values
    private var mSteps = 0;
    private var mStepsGoal = 1;

    function initialize() {
        MeterBehavior.initialize();
    }
    
    public function update() {
        var info = ActivityMonitor.getInfo();
        mSteps = info.steps;
        mStepsGoal = info.stepGoal;
        
        if (mStepsGoal < 1) {
            mStepsGoal = 1;
        }
    }
    
    public function getIconFont() {
        return gSymbolsFont;
    }
    
    public function getIconColor() {
        // Light up if the steps goal has been reached
        if (mSteps >= mStepsGoal) {
            return gColorIndicatorActive;
        } else {
            return gColorIndicatorInactive;
        }
    }
    
    public function getBackgroundColor() {
        return gColorBackground;
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
    
    public function getActiveMeterColor() {
        return gColorHighlights;
    }
    
    public function getInactiveMeterColor() {
        return gColorMeterBackground;
    }
    
}