using Toybox.System;

/**
 * Indicator for upcoming appointments. Does not support partial updates because
 * appointments will only happen one a minute at most anyway.
 */
class AppointmentIndicatorBehavior extends DefaultIndicatorBehavior {
    
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
        // TODO Change icon if there is an upcoming appointment
        return "G";
    }
    
    public function getValue() {
        if (mNextAppointment == null) {
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