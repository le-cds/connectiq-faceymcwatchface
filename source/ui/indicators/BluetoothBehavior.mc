using Toybox.System;

/**
 * Indicates whether the phone is currently connected or not. Supports partial
 * updates.
 */
class BluetoothBehavior extends OnOffBehavior {

    // Last known state of Bluetooth connection. When the current state differs
    // it is time to redraw.
    private var mPhoneConnected;
    
    public function initialize() {
        OnOffBehavior.initialize();
    }
    
    public function isOn() {
        mPhoneConnected = System.getDeviceSettings().phoneConnected;
        return mPhoneConnected;
    }
    
    public function getIconFont() {
        return gSymbolsFont;
    }
    
    public function getIconCharacter() {
        return 'A';
    }

    public function supportsPartialUpdate() {
        return true;
    }
    
    public function needsUpdate() {
        return mPhoneConnected != System.getDeviceSettings().phoneConnected;
    }
    
}