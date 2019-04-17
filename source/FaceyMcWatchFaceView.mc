using Toybox.Application;
using Toybox.Lang;
using Toybox.System;
using Toybox.WatchUi;


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
    private var mCalendarIndicator;
    private var mValueIndicators;
    private var mGoalMeterLeft;
    private var mGoalMeterRight;


    /**
     * Initialize things.
     */
    function initialize() {
        WatchFace.initialize();

        initializeColours();
        initializeFonts();
    }

    /**
     * Load your resources here.
     */
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));

        // Remember drawables
        mStatusIndicators = View.findDrawableById("StatusIndicators");
        mTimeLine = View.findDrawableById("Time");
        mCalendarIndicator = View.findDrawableById("CalendarIndicator");
        mValueIndicators = View.findDrawableById("ValueIndicators");
        mGoalMeterLeft = View.findDrawableById("GoalMeterLeft");
        mGoalMeterRight = View.findDrawableById("GoalMeterRight");
    }

    /**
     * Called by the app whenever the settings have changed.
     */
    function onSettingsChanged() {
        mCalendarIndicator.onSettingsChanged();
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
