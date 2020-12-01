using Toybox.Application;
using Toybox.Application.Properties;
using Toybox.Background;
using Toybox.Time;
using Toybox.WatchUi;
using FaceyMcWatchface.Indicators as Ind;
using FaceyMcWatchface.Meters as Met;

(:background)
class FaceyMcWatchFaceApp extends Application.AppBase {

    /**
     * Whether we're currently running as part of the background service or not.
     * This is updated in getServiceDelegate(), which is only called on the
     * background service, but not on the actual watchface.
     */
    private var mIsBackground = false;
    /** Our copy of our view. Used to pass setting update events along. */
    private var mView;


    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
        if (!mIsBackground) {
            // Be sure to save our appointments now
            storeCalendarIQData();
        }
    }

    // Return the initial view of your application here
    function getInitialView() {
        // Register the calendar service and load appointments from storage now
        // while we're at it
        startStopCalendarService();

        mView = new WatchFaceView();
        return [mView];
    }
    
    // Returns our current view.
    function getView() {
        return mView;
    }
    
    // Returns a view that allows for changing the watch settings
    function getSettingsView() {
        return [ new SettingsMenu(), new SettingsMenuInputDelegate() ];
    }

    // New app settings have been received.
    function onSettingsChanged() {
        if (!mIsBackground) {
            // The calendar service might not be necessary anymore
            startStopCalendarService();
        
            // Update UI
            mView.onSettingsChanged();
            WatchUi.requestUpdate();
        }
    }

    // Returns the background service to run.
    function getServiceDelegate() {
        mIsBackground = true;
        return [new CalendarIQServiceDelegate()];
    }

    // Receives data produced by our background service.
    function onBackgroundData(data) {
        // We would usually update the UI, but why bother when the
        // appointment item is updated on the full minute anyway
        processCalendarIQServiceData(data);
    }

    /**
     * Takes care of starting, restarting or stopping the calendar service in accordance
     * with the active settings.
     */
    function startStopCalendarService() {
        // We need to check whether any of the indicators and meters are based on data
        // received from CalendarIQ
        var requiresSync = false;
        for (var i = 0; i < Ind.INDICATOR_COUNT; i++) {
            var behavior = getProperty(Ind.INDICATOR_NAMES[i]);
            if (behavior == Ind.INDICATOR_BEHAVIOR_APPOINTMENTS
                || behavior == Ind.INDICATOR_BEHAVIOR_PHONE_BATTERY) {
                
                requiresSync = true;
                break;
            }
        }
        
        // Meters may require synchronisation as well
        if (!requiresSync) {
            for (var i = 0; i < Met.METER_COUNT; i++) {
                var behavior = getProperty(Met.METER_NAMES[i]);
                if (behavior == Met.METER_BEHAVIOR_PHONE_BATTERY) {
                    requiresSync = true;
                    break;
                }
            }
        }
        
        // If so, make sure the calendar background service is running
        if (requiresSync) {
            registerCalendarIQService();
        } else {
            unregisterCalendarIQService();
        }
    }

}
