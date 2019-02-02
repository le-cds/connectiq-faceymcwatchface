using Toybox.Application;
using Toybox.Background;
using Toybox.Time;
using Toybox.WatchUi;

(:background)
class FaceyMcWatchFaceApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        registerCalendarService();
        return [new FaceyMcWatchFaceView()];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() {
        WatchUi.requestUpdate();
    }

    // Returns the background service to run.
    function getServiceDelegate() {
        return [new CalendarServiceDelegate()];
    }

    // Receives data produced by our background service.
    function onBackgroundData(data) {
        if (processCalendarServiceData(data)) {
            WatchUi.requestUpdate();
        }
    }

}
