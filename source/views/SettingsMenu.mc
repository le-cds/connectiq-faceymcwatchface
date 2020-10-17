using Toybox.WatchUi;

/**
 * Implements the top-level settings menu and acts as its input delegate.
 */
class SettingsMenu extends WatchUi.Menu2 {

    // Our fine selection of menu items which we'll update from time to time
    var mAppointmentUpdateIntervalItem;

    function initialize() {
        Menu2.initialize({
            :title => loadResource(Rez.Strings.SettingsMenuTitle)
        });
        
        // Appointment Update Interval
        mAppointmentUpdateIntervalItem = new WatchUi.MenuItem(
            loadResource(Rez.Strings.AppointmentUpdateInterval_Title),
            "",
            APPOINTMENT_UPDATE_INTERVAL,
            {});
        addItem(mAppointmentUpdateIntervalItem);
    }
    
    // Update the subtitles of our buttons.
    public function onShow() {
        // Appointment Update Interval
        var appointmentUpdateSubtitle = Lang.format(
            loadResource(Rez.Strings.AppointmentUpdateInterval_Generic),
            [ Application.getApp().getProperty(APPOINTMENT_UPDATE_INTERVAL) ]);
        mAppointmentUpdateIntervalItem.setSubLabel(appointmentUpdateSubtitle);
    }
    
}

/**
 * Handles menu item selections in SettingsMenu.
 */
class SettingsMenuInputDelegate extends WatchUi.Menu2InputDelegate {

    public function initialize() {
        Menu2InputDelegate.initialize();
    }
    
    public function onSelect(item) {
        if (item.getId() == APPOINTMENT_UPDATE_INTERVAL) {
            WatchUi.pushView(
              new Rez.Menus.SettingsMenuAppointmentUpdateInterval(),
              new SettingsMenuAppointmentUpdateIntervalInputDelegate(),
              WatchUi.SLIDE_LEFT);
        }
    }
    
}