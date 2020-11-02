using Toybox.System;

/**
 * Indicates the number of floors climbed. Does not support partial updates.
 */
class IndicatorBehaviorFloorsClimbed extends DefaultIndicatorBehavior {
    
    // Cache most recent values
    private var mFloors = null;
    private var mFloorsGoal = null;
    
    public function initialize() {
        DefaultIndicatorBehavior.initialize(false);
    }
    
    public function update() {
        var info = ActivityMonitor.getInfo();
        
        if (info has :floorsClimbed) {
            mFloors = info.floorsClimbed;
            mFloorsGoal = info.floorsClimbedGoal;
            
            if (mFloorsGoal < 1) {
                mFloorsGoal = 1;
            }
        }
    }
    
    public function isIndicating() {
        // Light up if the floors goal has been reached
        return mFloors != null && mFloors >= mFloorsGoal;
    }
    
    public function getIconCharacter() {
        return 'F';
    }
    
    public function getValue() {
        return mFloors == null ? mFloors : mFloors.format("%d");
    }
    
}