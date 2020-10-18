/**
 * Implements behavior for displaying the active minutes per week.
 */
class MeterBehaviorActiveMinutes extends DefaultMeterBehavior {

    private var mActivity = 0;
    private var mActivityGoal = 1;

    function initialize() {
        DefaultMeterBehavior.initialize();
    }
    
    public function update() {
        var info = ActivityMonitor.getInfo();
        
        if (info has :activeMinutesWeek) {
            mActivity = info.activeMinutesWeek.total;
            mActivityGoal = info.activeMinutesWeekGoal;
            
            // Keep the goal from being too low
            if (mActivityGoal <= 0) {
                mActivityGoal = 1;
            }
        }
    }
    
    public function isIndicating() {
        // Light up if the user reached their goal
        return mActivity >= mActivityGoal;
    }
    
    public function getIconCharacter() {
        return 'K';
    }
    
    public function getCurrValue() {
        return mActivity;
    }
    
    public function getMaxValue() {
        return mActivityGoal;
    }
    
}