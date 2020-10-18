/**
 * Implements behavior for displaying the number of floors climbed.
 */
class MeterBehaviorFloorsClimbed extends DefaultMeterBehavior {
    
    // Cache most recent values
    private var mFloors = 0;
    private var mFloorsGoal = 1;

    function initialize() {
        DefaultMeterBehavior.initialize();
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
        // Light up if the steps goal has been reached
        return mFloors >= mFloorsGoal;
    }
    
    public function getIconCharacter() {
        return 'F';
    }
    
    public function getCurrValue() {
        return mFloors;
    }
    
    public function getMaxValue() {
        return mFloorsGoal;
    }
    
}