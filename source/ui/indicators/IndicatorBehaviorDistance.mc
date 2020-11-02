using Toybox.ActivityMonitor;
using Toybox.Application;
using Toybox.System;

/**
 * Indicates the distance travelled. Supports partial updates with a 10-seconds update
 * interval while the watch is sleeping and 1 second while it's awake.
 */
class IndicatorBehaviorDistance extends DefaultIndicatorBehavior {

    // Cache most recent values
    private var mDistance = null;
    
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