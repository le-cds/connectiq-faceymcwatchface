using Toybox.System;

/**
 * Indicator for the altitude. Does not support partial updates.
 */
class IndicatorBehaviorAltitude extends DefaultIndicatorBehavior {
    
    private var mAltitude = 0;

    public function initialize() {
        DefaultIndicatorBehavior.initialize(false);
    }
    
    public function update() {
        var info = ActivityMonitor.getInfo();
        
        if (info has :altitude) {
            mAltitude = info.altitude;
            
            if (mAltitude == null) {
                mAltitude = 0;
            } else {
                // The reading is in meters; convert to feet depending on system
                // settings
                var settings = System.getDeviceSettings();
                if (settings.elevationUnits == UNIT_STATUTE) {
                    mAltitude *= 3.28084;
                }
            }
        }
    }
    
    public function isIndicating() {
        // There is no altitude goal or anything like that
        return false;
    }
    
    public function getIconCharacter() {
        return "N";
    }
    
    public function getValue() {
        return toShortNumberString(mAltitude);
    }
    
}