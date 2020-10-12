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
    private var mTopLeftIndicator;
    private var mTopRightIndicator;
    private var mTimeLine;
    private var mCenterIndicator;
    private var mBottomLeftIndicator;
    private var mBottomCenterIndicator;
    private var mBottomRightIndicator;
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
        mTopLeftIndicator = View.findDrawableById("TopLeftIndicator");
        mTopRightIndicator = View.findDrawableById("TopRightIndicator");
        mTimeLine = View.findDrawableById("Time");
        mCenterIndicator = View.findDrawableById("CenterIndicator");
        mBottomLeftIndicator = View.findDrawableById("BottomLeftIndicator");
        mBottomCenterIndicator = View.findDrawableById("BottomCenterIndicator");
        mBottomRightIndicator = View.findDrawableById("BottomRightIndicator");
        mGoalMeterLeft = View.findDrawableById("GoalMeterLeft");
        mGoalMeterRight = View.findDrawableById("GoalMeterRight");
        
        mTopLeftIndicator.setBehavior(new BluetoothBehavior());
        mTopRightIndicator.setBehavior(new DoNotDisturbBehavior());
        mCenterIndicator.setBehavior(new AppointmentBehavior());
        mBottomLeftIndicator.setBehavior(new NotificationsBehavior());
        mBottomCenterIndicator.setBehavior(new BatteryBehavior());
        mBottomRightIndicator.setBehavior(new AlarmsBehavior());
    }

    /**
     * Called by the app whenever the settings have changed.
     */
    function onSettingsChanged() {
        if (Properties.getValue(ACTIVATE_APPOINTMENTS)) {
            mCenterIndicator.setBehavior(new AppointmentBehavior());
        } else {
            mCenterIndicator.setBehavior(null);
        }
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
        mTopLeftIndicator.partialDraw(dc);
        mTimeLine.drawSeconds(dc, true);
        mBottomLeftIndicator.partialDraw(dc);
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
