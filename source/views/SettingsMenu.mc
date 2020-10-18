using Toybox.WatchUi;

/**
 * Implements the top-level settings menu and acts as its input delegate.
 */
class SettingsMenu extends WatchUi.Menu2 {
    
    // Our fine selection of menu items which we'll update from time to time
    private var mAppointmentUpdateIntervalItem;
    private var mIndicatorItems;
    private var mMeterItems;

    function initialize() {
        Menu2.initialize({
            :title => loadResource(Rez.Strings.SettingsMenuTitle)
        });
        
        // Appointment Update Interval
        mAppointmentUpdateIntervalItem = new WatchUi.MenuItem(
            loadResource(Rez.Strings.AppointmentUpdateInterval),
            "",
            APPOINTMENT_UPDATE_INTERVAL,
            {});
        addItem(mAppointmentUpdateIntervalItem);
        
        // Indicators
        mIndicatorItems = new [INDICATOR_COUNT];
        for (var i = 0; i < INDICATOR_COUNT; i++) {
            mIndicatorItems[i] = createIndicatorSetting(i);
            addItem(mIndicatorItems[i]);
        }
        
        // Meters
        mMeterItems = new [METER_COUNT];
        for (var i = 0; i < METER_COUNT; i++) {
            mMeterItems[i] = createMeterSetting(i);
            addItem(mMeterItems[i]);
        }
    }
    
    private function createIndicatorSetting(indicatorId) {
        // We need to map the ID to a String resource to be displayed
        return new WatchUi.MenuItem(
            loadResource(INDICATOR_TO_STRING_RESOURCE[indicatorId]),
            "",
            INDICATOR_NAMES[indicatorId],
            {});
    }
    
    private function createMeterSetting(meterId) {
        // We need to map the ID to a String resource to be displayed
        return new WatchUi.MenuItem(
            loadResource(METER_TO_STRING_RESOURCE[meterId]),
            "",
            METER_NAMES[meterId],
            {});
    }
    
    // Update the subtitles of our buttons.
    public function onShow() {
        // Appointment Update Interval
        var appointmentUpdateSubtitle = Lang.format(
            loadResource(Rez.Strings.AppointmentUpdateInterval_Generic),
            [ Application.getApp().getProperty(APPOINTMENT_UPDATE_INTERVAL) ]);
        mAppointmentUpdateIntervalItem.setSubLabel(appointmentUpdateSubtitle);
        
        // Indicators
        for (var i = 0; i < INDICATOR_COUNT; i++) {
            var behaviorId = Application.getApp().getProperty(INDICATOR_NAMES[i]);
            var subLabel = loadResource(INDICATOR_BEHAVIOR_TO_STRING_RESOURCE[behaviorId]);
            mIndicatorItems[i].setSubLabel(subLabel);
        }
        
        // Meters
        for (var i = 0; i < METER_COUNT; i++) {
            var behaviorId = Application.getApp().getProperty(METER_NAMES[i]);
            var subLabel = loadResource(METER_BEHAVIOR_TO_STRING_RESOURCE[behaviorId]);
            mMeterItems[i].setSubLabel(subLabel);
        }
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
        
        // Check if it's one of the indicator configuration items
        var indicatorIdx = INDICATOR_NAMES.indexOf(item.getId());
        if (indicatorIdx >= 0) {
            WatchUi.pushView(
                new Rez.Menus.SettingsMenuIndicatorSelection(),
                new SettingsMenuIndicatorMeterSelectionInputDelegate(
                    INDICATOR_NAMES[indicatorIdx],
                    INDICATOR_BEHAVIOR_NAMES),
                WatchUi.SLIDE_LEFT);
            return;
        }
        
        // Check if it's one of the meter configuration items
        var meterIdx = METER_NAMES.indexOf(item.getId());
        if (meterIdx >= 0) {
            WatchUi.pushView(
                new Rez.Menus.SettingsMenuMeterSelection(),
                new SettingsMenuIndicatorMeterSelectionInputDelegate(
                    METER_NAMES[meterIdx],
                    METER_BEHAVIOR_NAMES),
                WatchUi.SLIDE_LEFT);
            return;
        }
    }
    
    public function onBack() {
        // Ensure that the watchface reloads any settings that have been changed
        Application.getApp().onSettingsChanged();
        
        // We're done here!
        popView(WatchUi.SLIDE_RIGHT);
    }
    
}