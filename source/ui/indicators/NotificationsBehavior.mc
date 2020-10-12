using Toybox.System;

/**
 * Indicates the number of unread notifications. Supports partial updates.
 */
class NotificationsBehavior extends ValueBehavior {

    // Last known number of notifications. When the current number differs it
    // is time to redraw.
    private var mNotifications;
    
    public function initialize() {
        ValueBehavior.initialize(true);
    }

    public function needsUpdate() {
        return mNotifications != System.getDeviceSettings().notificationCount;
    }
    
    public function update() {
        mNotifications = System.getDeviceSettings().notificationCount;
    }
    
    public function getIconFont() {
        return gSymbolsFont;
    }
    
    public function getIconColor() {
        // The indicator should light up if there are notifications
        if (mNotifications > 0) {
            return gColorIndicatorActive;
        } else {
            return gColorIndicatorInactive;
        }
    }
    
    public function getIconCharacter() {
        return 'C';
    }
    
    public function getValueFont() {
        return gIndicatorFont;
    }
    
    public function getValueColor() {
        return gColorIndicatorText;
    }
    
    public function getValue() {
        return mNotifications.format("%d");
    }
    
}