using Toybox.ActivityMonitor;
using Toybox.Application;
using Toybox.Lang;
using Toybox.System;
using Toybox.WatchUi;


enum /* GOAL_TYPES */ {
    GOAL_TYPE_BATTERY = -1,
    GOAL_TYPE_STEPS = 0,
    GOAL_TYPE_FLOORS_CLIMBED
}


// Return a dictionary that contains the :current and :max value of the given goal
// type.
function getValuesForGoalType(type) {
    var values = {
        :current => 0,
        :max => 1
    };

    var info = ActivityMonitor.getInfo();

    switch (type) {
        case GOAL_TYPE_STEPS:
            values[:current] = info.steps;
            values[:max] = info.stepGoal;
            break;

        case GOAL_TYPE_FLOORS_CLIMBED:
            if (info has :floorsClimbed) {
                values[:current] = info.floorsClimbed;
                values[:max] = info.floorsClimbedGoal;
            } else {
                values[:isValid] = false;
            }

            break;

        case GOAL_TYPE_BATTERY:
            values[:current] = Math.floor(System.getSystemStats().battery);
            values[:max] = 100;
            break;
    }

    // #16: If user has set goal to zero, or negative (in simulator), show as invalid. Set max to 1
    // to avoid divide-by-zero crash in GoalMeter.getSegmentScale().
    if (values[:max] < 1) {
        values[:max] = 1;
    }

    return values;
}


/**
 * The watch face's main view class.
 *
 * This code is based on code from the Crystal watch face, which can be found at:
 * https://github.com/warmsound/crystal-face
 */
class FaceyMcWatchFaceView extends WatchUi.WatchFace {

    // Symbols for the goal meters
    private const SYMBOL_STEPS = "E";
    private const SYMBOL_STAIRS = "F";

    // Cache references to drawables immediately after layout, to avoid expensive findDrawableById()
    // calls later WHEN TIME IS SCARCE!!!
    private var mStatusIndicators;
    private var mTimeLine;
    private var mValueIndicators;
    private var mGoalMeterLeft;
    private var mGoalMeterRight;


    /**
     * Initialize things.
     */
    function initialize() {
        WatchFace.initialize();
    }

    /**
     * Load your resources here.
     */
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));

        // Remember drawables
        mStatusIndicators = View.findDrawableById("StatusIndicators");
        mTimeLine = View.findDrawableById("Time");
        mValueIndicators = View.findDrawableById("ValueIndicators");
        mGoalMeterLeft = View.findDrawableById("GoalMeterLeft");
        mGoalMeterRight = View.findDrawableById("GoalMeterRight");
    }

    /**
     * Called when this View is brought to the foreground. Restore
     * the state of this View and prepare it to be shown. This includes
     * loading resources into memory.
     */
    function onShow() {
    }

    /**
     * Called when this View is removed from the screen. Save the state of
     * this View here. This includes freeing resources from memory.
     */
    function onHide() {
    }

    /**
     * Update the screen.
     */
    function onUpdate(dc) {
        // Clear any partial update clipping.
        dc.clearClip();

        // Update the goal meters
        var leftValues = getValuesForGoalType(GOAL_TYPE_STEPS);
        mGoalMeterLeft.setValues(SYMBOL_STEPS, leftValues[:current], leftValues[:max]);

        var rightValues = getValuesForGoalType(GOAL_TYPE_FLOORS_CLIMBED);
        mGoalMeterRight.setValues(SYMBOL_STAIRS, rightValues[:current], rightValues[:max]);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    /**
     * Update only the most pressing things here.
     */
    function onPartialUpdate(dc) {
        mStatusIndicators.drawBluetooth(dc, true);
        mTimeLine.drawSeconds(dc, true);
        mValueIndicators.drawNotifications(dc, true);
    }

    /**
     * Terminate any active timers and prepare for slow updates.
     */
    function onEnterSleep() {
    }

    /**
     * The user has just looked at their watch. Timers and animations may
     * be started here.
     */
    function onExitSleep() {
    }

}
