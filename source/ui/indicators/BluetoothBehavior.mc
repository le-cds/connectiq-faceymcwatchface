using Toybox.System;

/**
 * Indicates whether the phone is currently connected or not. Supports partial
 * updates.
 */
class BluetoothBehavior extends IconBehavior {

    // Last known state of Bluetooth connection. When the current state differs
    // it is time to redraw.
    private var mPhoneConnected;
    
    public function initialize() {
        IconBehavior.initialize(true);
    }
    
    public function needsUpdate() {
        return mPhoneConnected != System.getDeviceSettings().phoneConnected;
    }
    
    public function update() {
        mPhoneConnected = System.getDeviceSettings().phoneConnected;
    }
    
    public function getIconFont() {
        return gSymbolsFont;
    }
    
    public function getIconColor() {
        // The indicator should light up if there is a connection
        if (mPhoneConnected) {
            return gColorIndicatorActive;
        } else {
            return gColorIndicatorInactive;
        }
    }
    
    public function getIconCharacter() {
        return 'A';
    }
    
}