using Toybox.System;

/**
 * Indicates when we last received data from CalendarIQ.
 */
class IndicatorBehaviorSyncTime extends DefaultIndicatorBehavior {

    public function initialize() {
        DefaultIndicatorBehavior.initialize(false);
    }
    
    public function getIconCharacter() {
        return 'R';
    }
    
    public function getValue() {
        if (last_refresh > 0) {
            var info = displayableMoment(new Time.Moment(last_refresh));
            return Lang.format(
                "$1$:$2$$3$",
                [
                    info[:hour],
                    info[:minute],
                    info[:ampm]
                ]);
        } else {
            return null;
        }
    }
    
}