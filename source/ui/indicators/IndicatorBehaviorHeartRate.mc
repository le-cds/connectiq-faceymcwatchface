using Toybox.ActivityMonitor;
using Toybox.Application;
using Toybox.System;

/**
 * Indicates the heart rate. Supports partial updates with a 2-second update
 * interval.
 */
class IndicatorBehaviorHeartRate extends DefaultIndicatorBehavior {

    // Last known heart rate.
    private var mHeartRate = 0;
    
    public function initialize() {
        DefaultIndicatorBehavior.initialize(true);
    }
    
    public function supportsPartialUpdate() {
        return true;
    }

    public function wantsPartialUpdate() {
        return System.getClockTime().sec % 2 == 0;
    }
    
    public function update() {
        // Attempt to retrieve current heart rate via activity info first (thanks
        // to the Crystal watchface for the idea!)
        var info = Activity.getActivityInfo();
        var hr = info.currentHeartRate;
        
        if (hr == null) {
            // That hasn't worked; try again with the activity monitor's history,
            // which does not seem to be updated as often
            var sample = ActivityMonitor.getHeartRateHistory(1, true).next();
            
            if (sample != null) {
                hr = sample.heartRate;
            }
        }
        
        // The value we obtained might be invalid
        if (hr == ActivityMonitor.INVALID_HR_SAMPLE) {
            hr = null;
        }
        
        mHeartRate = hr;
    }
    
    public function isIndicating() {
        // This thing never lights up
        return false;
    }
    
    public function getIconCharacter() {
        return "I";
    }
    
    public function getValue() {
        return mHeartRate;
    }
    
    public function getLongestValue() {
        return "000";
    }
    
}