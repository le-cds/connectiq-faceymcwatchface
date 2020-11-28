using Toybox.System;

/**
 * Indicates the number of unread notifications. Does not support partial updates.
 */
class IndicatorBehaviorNotifications extends DefaultIndicatorBehavior {

    // Last known number of notifications. When the current number differs it
    // is time to redraw.
    private var mNotifications;
    
    public function initialize() {
        DefaultIndicatorBehavior.initialize(true);
    }
    
    public function update() {
        mNotifications = System.getDeviceSettings().notificationCount;
    }
    
    public function isIndicating() {
        // The indicator should light up if there are notifications
        return mNotifications > 0;
    }
    
    public function getIconCharacter() {
        return 'C';
    }
    
    public function getValue() {
        return mNotifications.format("%d");
    }
    
}