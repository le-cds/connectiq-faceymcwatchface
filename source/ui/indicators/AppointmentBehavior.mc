using Toybox.System;

/**
 * Indicator for upcoming appointments. Does not support partial updates because
 * appointments will only happen one a minute at most anyway.
 */
class AppointmentBehavior extends ValueBehavior {
    
    /**
     * We cache the next appointment during update() to avoid having to retrieve
     * it multiple times.
     */
    private var mNextAppointment = null;

    public function initialize() {
        ValueBehavior.initialize(false);
    }
    
    public function update() {
        mNextAppointment = getNextAppointment();
    }
    
    public function getIconFont() {
        return gSymbolsFont;
    }
    
    public function getIconColor() {
        // The indicator should light up if there is a next appointment
        if (mNextAppointment != null) {
            return gColorIndicatorActive;
        } else {
            return gColorIndicatorInactive;
        }
    }
    
    public function getBackgroundColor() {
        return gColorBackground;
    }
    
    public function getIconCharacter() {
        // TODO Change icon if there is an upcoming appointment
        return "G";
    }
    
    public function getValueFont() {
        return gIndicatorFont;
    }
    
    public function getValueColor() {
        return gColorIndicatorText;
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