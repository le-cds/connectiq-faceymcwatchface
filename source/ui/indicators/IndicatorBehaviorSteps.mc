using Toybox.ActivityMonitor;
using Toybox.Application;
using Toybox.System;

/**
 * Indicates the number of steps stepped. Does not support partial updates.
 */
class IndicatorBehaviorSteps extends DefaultIndicatorBehavior {

    // Cache most recent values
    private var mSteps = null;
    private var mStepsGoal = null;
    
    public function initialize() {
        DefaultIndicatorBehavior.initialize(true);
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
        return mSteps != null && mSteps >= mStepsGoal;
    }
    
    public function getIconCharacter() {
        return 'E';
    }
    
    public function getValue() {
        return mSteps == null ? mSteps : toShortNumberString(mSteps);
    }
    
}