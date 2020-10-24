using Toybox.System;

/**
 * Indicates the number of floors descended. Does not support partial updates.
 */
class IndicatorBehaviorFloorsDescended extends DefaultIndicatorBehavior {
    
    // Cache most recent values
    private var mFloors = 0;
    
    public function initialize() {
        DefaultIndicatorBehavior.initialize(false);
    }
    
    public function update() {
        var info = ActivityMonitor.getInfo();
        
        if (info has :floorsDescended) {
            mFloors = info.floorsDescended;
        }
    }
    
    public function isIndicating() {
        // We don't have a goal for this metric, so don't bother
        return false;
    }
    
    public function getIconCharacter() {
        return 'L';
    }
    
    public function getValue() {
        return mFloors.format("%d");
    }
    
}