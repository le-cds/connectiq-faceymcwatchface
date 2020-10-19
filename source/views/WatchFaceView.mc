using Toybox.Application;
using Toybox.Lang;
using Toybox.System;
using Toybox.WatchUi;
using FaceyMcWatchface.Indicators as Ind;
using FaceyMcWatchface.Meters as Met;


/**
 * The watch face's main view class.
 *
 * This code is based on code from the Crystal watch face, which can be found at:
 * https://github.com/warmsound/crystal-face
 */
class WatchFaceView extends WatchUi.WatchFace {
    
    // Whether the watch is in high or low power mode.
    private var mHighPowerMode = true;

    // Cache references to drawables immediately after layout, to avoid expensive findDrawableById()
    // calls later WHEN TIME IS SCARCE!!!
    private var mTimeLine;
    private var mIndicators;
    private var mMeters;


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
        mTimeLine = View.findDrawableById("Time");
        mIndicators = assembleDrawables(Ind.INDICATOR_COUNT, Ind.INDICATOR_NAMES);
        mMeters = assembleDrawables(Met.METER_COUNT, Met.METER_NAMES);
        
        // Initialize with behaviors
        onSettingsChanged();
    }
    
    /**
     * Returns an array containing the drawables with the given names.
     */
    private function assembleDrawables(number, names) {
        var result = new [number];
        for (var i = 0; i < number; i++) {
            result[i] = View.findDrawableById(names[i]);
        }
        return result;
    }

    /**
     * Called by the app whenever the settings have changed.
     */
    function onSettingsChanged() {
        for (var i = 0; i < Ind.INDICATOR_COUNT; i++) {
            var behaviorId = Application.getApp().getProperty(Ind.INDICATOR_NAMES[i]);
            var behavior = createIndicatorBehavior(behaviorId);
            mIndicators[i].setBehavior(behavior);
        }
        
        for (var i = 0; i < Met.METER_COUNT; i++) {
            var behaviorId = Application.getApp().getProperty(Met.METER_NAMES[i]);
            var behavior = createMeterBehavior(behaviorId);
            mMeters[i].setBehavior(behavior);
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

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    /**
     * Update only the most pressing things here.
     */
    function onPartialUpdate(dc) {
        mTimeLine.drawSeconds(dc);
        
        // Give indicators a chance for partial updates
        for (var i = 0; i < Ind.INDICATOR_COUNT; i++) {
            mIndicators[i].partialDraw(dc);
        }
    }

    /**
     * Terminate any active timers and prepare for slow updates.
     */
    function onEnterSleep() {
        mHighPowerMode = false;
    }

    /**
     * The user has just looked at their watch. Timers and animations may
     * be started here.
     */
    function onExitSleep() {
        mHighPowerMode = true;
    }
    
    function isHighPowerMode() {
        return mHighPowerMode;
    }
    
}
