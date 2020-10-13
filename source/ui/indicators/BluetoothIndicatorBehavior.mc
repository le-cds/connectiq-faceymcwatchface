using Toybox.System;

/**
 * Indicates whether the phone is currently connected or not. Supports partial
 * updates.
 */
class BluetoothIndicatorBehavior extends DefaultIndicatorBehavior {

    // Last known state of Bluetooth connection. When the current state differs
    // it is time to redraw.
    private var mPhoneConnected;
    
    public function initialize() {
        DefaultIndicatorBehavior.initialize(true);
    }
    
    public function wantsPartialUpdate() {
        return mPhoneConnected != System.getDeviceSettings().phoneConnected;
    }
    
    public function update() {
        mPhoneConnected = System.getDeviceSettings().phoneConnected;
    }
    
    public function isIndicating() {
        // The indicator should light up if there is a connection
        return mPhoneConnected;
    }
    
    public function getIconCharacter() {
        return 'A';
    }
    
    public function getValue() {
        return "Bla";
    }
    
}