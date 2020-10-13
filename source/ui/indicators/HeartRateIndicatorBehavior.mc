using Toybox.ActivityMonitor;
using Toybox.System;

/**
 * Indicates the heart rate. Supports partial updates.
 */
class HeartRateIndicatorBehavior extends DefaultIndicatorBehavior {

    // Last known heart rate. When the current number differs it is time to redraw.
    // The only reason for this optimization is to disable partial updates while
    // the watch is not being worn
    private var mHeartRate = 0;
    
    public function initialize() {
        DefaultIndicatorBehavior.initialize(true);
    }

    public function wantsPartialUpdate() {
        var heartRateIterator = ActivityMonitor.getHeartRateHistory(1, true);
        var heartRateSample = heartRateIterator.next();
        var newHeartRate = (heartRateSample != null) ? heartRateSample.heartRate : 0;
        
        return getCurrentHeartRate() != mHeartRate;
    }
    
    public function update() {
        mHeartRate = getCurrentHeartRate();
    }
    
    private function getCurrentHeartRate() {
        var heartRateIterator = ActivityMonitor.getHeartRateHistory(1, true);
        var heartRateSample = heartRateIterator.next();
        return (heartRateSample != null) ? heartRateSample.heartRate : 0;
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