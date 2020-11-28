using Toybox.ActivityMonitor;
using Toybox.Application;
using Toybox.System;

/**
 * Indicates the distance travelled. Does not support partial updates.
 */
class IndicatorBehaviorDistance extends DefaultIndicatorBehavior {

    // Cache most recent values
    private var mDistance = null;
    
    public function initialize() {
        DefaultIndicatorBehavior.initialize(true);
    }

    public function update() {
        var info = ActivityMonitor.getInfo();
        
        // The distance field is in cm, which is too high-resolution for us
        mDistance = info.distance;
        
        if (mDistance != null) {
            mDistance /= 100;
        
            if (System.getDeviceSettings().distanceUnits == System.UNIT_STATUTE) {
                // Convert to feet
                mDistance *= 3.28084;
            }
        }
    }
    
    public function isIndicating() {
        // There's no goal to reach
        return false;
    }
    
    public function getIconCharacter() {
        return 'O';
    }
    
    public function getValue() {
        return mDistance == null ? mDistance : toShortNumberString(mDistance);
    }
    
}