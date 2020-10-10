using Toybox.System;

/**
 * Indicator for the watch's Do Not Disturb setting. Does not support partial
 * updates since changing this setting entails leaving the watchface.
 */
class DoNotDisturbIndicator extends BaseIndicator {

    public function initialize(params) {
        BaseIndicator.initialize(params);
        
        mIconSize = 16;
    }
    
    protected function isIndicating() {
        return System.getDeviceSettings().doNotDisturb;
    }
    
    protected function getIconCharacter() {
        return 'B';
    }
    
}