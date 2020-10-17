/**
 * Implements behavior for displaying the movement bar.
 */
class MoveBarMeterBehavior extends DefaultMeterBehavior {

    /** Maximum move bar level. */    
    private var mMoveBarMax = 1;
    /** Most recent current move bar level. */
    private var mMoveBar = 1;

    function initialize() {
        DefaultMeterBehavior.initialize();
    }
    
    public function update() {
        var info = ActivityMonitor.getInfo();
        
        if (info has :moveBarLevel) {
            mMoveBarMax = ActivityMonitor.MOVE_BAR_LEVEL_MAX - ActivityMonitor.MOVE_BAR_LEVEL_MIN;
            mMoveBar = info.moveBarLevel - ActivityMonitor.MOVE_BAR_LEVEL_MIN;
        }
    }
    
    public function isIndicating() {
        // Light up if the user should move along
        return mMoveBar >= mMoveBarMax;
    }
    
    public function getIconCharacter() {
        return 'J';
    }
    
    public function getCurrValue() {
        return mMoveBar;
    }
    
    public function getMaxValue() {
        return mMoveBarMax;
    }
    
}