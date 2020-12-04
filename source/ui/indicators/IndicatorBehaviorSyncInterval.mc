using Toybox.System;

/**
 * Indicates the number of minutes between consecutive snychronisation attempts.
 */
class IndicatorBehaviorSyncInterval extends DefaultIndicatorBehavior {

    public function initialize() {
        DefaultIndicatorBehavior.initialize(false);
    }
    
    public function getIconCharacter() {
        return 'Q';
    }
    
    public function getValue() {
        if (sync_interval == null) {
            return null;
        } else {
            // Seconds -> Minutes
            return sync_interval / 60;
        }
    }
    
}