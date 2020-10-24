using Toybox.ActivityMonitor;
using Toybox.Application;
using Toybox.System;

/**
 * Indicates the number of steps stepped. Supports partial updates with a 10-seconds update
 * interval while the watch is sleeping and 1 second while it's awake.
 */
class IndicatorBehaviorSteps extends DefaultIndicatorBehavior {

    // Cache most recent values
    private var mSteps = 0;
    private var mStepsGoal = 1;
    
    public function initialize() {
        DefaultIndicatorBehavior.initialize(true);
    }

    public function wantsPartialUpdate() {
        // We always want a partial update if the watch is in high power mode;
        // otherwise only every 10 seconds
        return Application.getApp().getView().isHighPowerMode()
            || System.getClockTime().sec % 10 == 0;
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
    
    public function getValue() {
        return toShortNumberString(mSteps);
    }
    
}