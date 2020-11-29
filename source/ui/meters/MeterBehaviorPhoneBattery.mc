/**
 * Implements behavior for displaying the phone's battery charge.
 */
class MeterBehaviorPhoneBattery extends DefaultMeterBehavior {

    // Last known phone battery state
    private var mBattLevel = null;
    private var mIsCharging = false;

    function initialize() {
        DefaultMeterBehavior.initialize();
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
    
    public function getCurrValue() {
        return mBattLevel == null ? 0 : mBattLevel;
    }
    
    public function getMaxValue() {
        return 100;
    }
    
}