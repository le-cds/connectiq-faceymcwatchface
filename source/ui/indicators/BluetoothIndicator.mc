using Toybox.System;

/**
 * Indicates whether the phone is currently connected or not. Supports partial
 * updates.
 */
class BluetoothIndicator extends BaseIndicator {

    // Last known state of Bluetooth connection. When the current state differs
    // it is time to redraw.
    private var mPhoneConnected;

    public function initialize(params) {
        BaseIndicator.initialize(params);
        
        mIconSize = 16;
    }

    public function supportsPartialUpdate() {
        return true;
    }
    
    protected function needsUpdate() {
        return mPhoneConnected != System.getDeviceSettings().phoneConnected;
    }
    
    protected function isIndicating() {
        mPhoneConnected = System.getDeviceSettings().phoneConnected;
        return mPhoneConnected;
    }
    
    protected function getIconCharacter() {
        return 'A';
    }
    
}