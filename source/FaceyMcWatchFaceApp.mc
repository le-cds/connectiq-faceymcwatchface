using Toybox.Application;
using Toybox.Application.Properties;
using Toybox.Background;
using Toybox.Time;
using Toybox.WatchUi;
using FaceyIndicatorConstants as FIC;

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
            storeAppointments();
        }
    }

    // Return the initial view of your application here
    function getInitialView() {
        // Register the calendar service and load appointments from storage now
        // while we're at it
        initializeCalendarService();
        loadAppointments();

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
            // The calendar service might have had its settings changed
            initializeCalendarService();
    
            mView.onSettingsChanged();
    
            // Trigger a UI update to reflect the new settings
            WatchUi.requestUpdate();
        }
    }

    // Returns the background service to run.
    function getServiceDelegate() {
        mIsBackground = true;
        return [new CalendarServiceDelegate()];
    }

    // Receives data produced by our background service.
    function onBackgroundData(data) {
        // We would usually update the UI, but why bother when the
        // appointment item is updated on the full minute anyway
        processCalendarServiceData(data);
    }

    /**
     * Takes care of starting, restarting or stopping the calendar service in accordance
     * with the active settings.
     */
    function initializeCalendarService() {
        // We need to check whether any of the indicators is supposed to show appointments
        var appointments = false;
        for (var i = 0; i < FIC.INDICATOR_COUNT; i++) {
            if (getProperty(FIC.INDICATOR_NAMES[i]) == FIC.INDICATOR_BEHAVIOR_APPOINTMENTS) {
                appointments = true;
                break;
            }
        }
        
        // If so, make sure the calendar background service is running
        if (appointments) {
            registerCalendarService(Properties.getValue(APPOINTMENT_UPDATE_INTERVAL));
        } else {
            unregisterCalendarService();
        }
    }

}
