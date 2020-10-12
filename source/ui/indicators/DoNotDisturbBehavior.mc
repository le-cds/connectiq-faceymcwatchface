using Toybox.System;

/**
 * Indicator for the watch's Do Not Disturb setting. Does not support partial
 * updates since changing this setting entails leaving the watchface.
 */
class DoNotDisturbBehavior extends OnOffBehavior {
    
    public function initialize() {
        OnOffBehavior.initialize();
    }
    
    public function isOn() {
        return System.getDeviceSettings().doNotDisturb;
    }
    
    public function getIconFont() {
        return gSymbolsFont;
    }
    
    public function getIconCharacter() {
        return 'B';
    }
    
}