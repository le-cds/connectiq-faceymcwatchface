using Toybox.System;

/**
 * Indicator for the phone's battery state. Does not support partial updates.
 */
class IndicatorBehaviorPhoneBattery extends DefaultIndicatorBehavior {

    // Last known phone battery state
    private var mBattLevel = null;
    private var mIsCharging = false;
    
    public function initialize() {
        DefaultIndicatorBehavior.initialize(false);
    }
    
    public function update() {
        mBattLevel = getPhoneBatteryLevel();
        
        if (mBattLevel != null && mBattLevel < 0) {
            mBattLevel *= -1;
            mIsCharging = true;
        
        } else {
            mIsCharging = false;
        }
    }
    
    public function isIndicating() {
        // The indicator should light up if the battery level has dropped below 20%
        return mBattLevel != null && mBattLevel < 20;
    }
    
    public function getIconCharacter() {
        return mIsCharging ? 'p' : 'P';
    }
    
    public function getValue() {
        if (mBattLevel == null) {
            return null;
        } else {
            return mBattLevel.format("%d") + "%";
        }
    }
    
}