using Toybox.System;

/**
 * Indicator for upcoming appointments. Does not support partial updates because
 * appointments will only happen one a minute at most anyway.
 */
class IndicatorBehaviorAppointments extends DefaultIndicatorBehavior {
    
    /**
     * We cache the next appointment during update() to avoid having to retrieve
     * it multiple times.
     */
    private var mNextAppointment = null;

    public function initialize() {
        DefaultIndicatorBehavior.initialize(false);
    }
    
    public function update() {
        mNextAppointment = getNextAppointment();
    }

    public function isIndicating() {    
        return mNextAppointment != null;
    }
    
    public function getIconCharacter() {
        if (mNextAppointment == null) {
            return "G";
        } else {
            return "H";
        }
    }
    
    public function getValue() {
        if (mNextAppointment == null) {
            // We do not want to display a "-"
            return "";
        } else {
            var info = displayableMoment(mNextAppointment);
            return Lang.format(
                "$1$:$2$$3$",
                [
                    info[:hour],
                    info[:minute],
                    info[:ampm]
                ]);
        }
    }
    
}