using Toybox.WatchUi;

/**
 * Input delegate for the SettingsMenuAppointmentUpdateInterval menu.
 */
class SettingsMenuAppointmentUpdateIntervalInputDelegate extends WatchUi.Menu2InputDelegate {

    /**
     * A mapping of menu item IDs to the update intervals they represent.
     */
    private const ITEM_TO_INTERVAL = {
        :AppointmentUpdateInterval_5 => 5,
        :AppointmentUpdateInterval_10 => 10,
        :AppointmentUpdateInterval_15 => 15,
        :AppointmentUpdateInterval_20 => 20,
        :AppointmentUpdateInterval_30 => 30,
        :AppointmentUpdateInterval_60 => 60
    };

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    public function onSelect(item) {
        // Store the new update interval in the settings
        var updateInterval = ITEM_TO_INTERVAL[item.getId()];
        Application.getApp().setProperty(APPOINTMENT_UPDATE_INTERVAL, updateInterval);
        
        // We're done here!
        popView(WatchUi.SLIDE_RIGHT);
    }
    
}
