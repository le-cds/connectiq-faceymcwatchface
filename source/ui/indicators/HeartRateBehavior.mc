using Toybox.ActivityMonitor;
using Toybox.System;

/**
 * Indicates the heart rate. Supports partial updates.
 */
class HeartRateBehavior extends ValueBehavior {

    // Last known heart rate. When the current number differs it is time to redraw.
    // The only reason for this optimization is to disable partial updates while
    // the watch is not being worn
    private var mHeartRate = 0;
    
    public function initialize() {
        ValueBehavior.initialize(true);
    }

    public function needsUpdate() {
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
    
    public function getIconFont() {
        return gSymbolsFont;
    }
    
    public function getIconColor() {
        // This thing never lights up
        return gColorIndicatorInactive;
    }
    
    public function getBackgroundColor() {
        return gColorBackground;
    }
    
    public function getIconCharacter() {
        // TODO Proper heart icon
        return 'C';
    }
    
    public function getValueFont() {
        return gIndicatorFont;
    }
    
    public function getValueColor() {
        return gColorIndicatorText;
    }
    
    public function getValue() {
        return mHeartRate.format("%d");
    }
    
}