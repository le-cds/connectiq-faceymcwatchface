using Toybox.ActivityMonitor;
using Toybox.Application;
using Toybox.System;

/**
 * Indicates the heart rate. Supports partial updates with a 10-seconds update
 * interval while the watch is sleeping and 1 second while it's awake.
 */
class IndicatorBehaviorHeartRate extends DefaultIndicatorBehavior {

    // Last known heart rate.
    private var mHeartRate = 0;
    
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
        mHeartRate = getCurrentHeartRate();
    }
    
    private function getCurrentHeartRate() {
        // Attempt to retrieve current heart rate via activity info first (thanks
        // to the Crystal watchface for the idea!)
        var info = Activity.getActivityInfo();
        var hr = info.currentHeartRate;
        
        if (hr == null) {
            // That hasn't worked; try again with the activity monitor's history,
            // which does not seem to be updated as often
            var sample = ActivityMonitor.getHeartRateHistory(1, true).next();
            
            if (sample != null && sample != ActivityMonitor.INVALID_HR_SAMPLE) {
                hr = sample.heartRate;
            }
        }
        
        return (hr != null) ? hr : 0;
    }
    
    public function isIndicating() {
        // This thing never lights up
        return false;
    }
    
    public function getIconCharacter() {
        return 'I';
    }
    
    public function getValue() {
        return mHeartRate.format("%d");
    }
    
}