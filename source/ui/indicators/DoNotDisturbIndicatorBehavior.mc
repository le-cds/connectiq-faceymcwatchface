using Toybox.System;

/**
 * Indicator for the watch's Do Not Disturb setting. Does not support partial
 * updates since changing this setting entails leaving the watchface.
 */
class DoNotDisturbIndicatorBehavior extends DefaultIndicatorBehavior {
    
    public function initialize() {
        DefaultIndicatorBehavior.initialize(false);
    }
    
    public function isIndicating() {
        // The indicator should light up if DND is active
        return System.getDeviceSettings().doNotDisturb;
    }
    
    public function getIconCharacter() {
        return 'B';
    }
    
}