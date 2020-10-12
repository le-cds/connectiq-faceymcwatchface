using Toybox.System;

/**
 * Indicator for the watch's Do Not Disturb setting. Does not support partial
 * updates since changing this setting entails leaving the watchface.
 */
class DoNotDisturbBehavior extends IconBehavior {
    
    public function initialize() {
        IconBehavior.initialize(false);
    }
    
    public function getIconFont() {
        return gSymbolsFont;
    }
    
    public function getIconColor() {
        // The indicator should light up if DND is active
        if (System.getDeviceSettings().doNotDisturb) {
            return gColorIndicatorActive;
        } else {
            return gColorIndicatorInactive;
        }
    }
    
    public function getIconCharacter() {
        return 'B';
    }
    
}