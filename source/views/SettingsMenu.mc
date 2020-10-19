using Toybox.WatchUi;
using FaceyMcWatchface.Indicators as Ind;
using FaceyMcWatchface.Meters as Met;

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
        mIndicatorItems = new [Ind.INDICATOR_COUNT];
        for (var i = 0; i < Ind.INDICATOR_COUNT; i++) {
            mIndicatorItems[i] = createIndicatorSetting(i);
            addItem(mIndicatorItems[i]);
        }
        
        // Meters
        mMeterItems = new [Met.METER_COUNT];
        for (var i = 0; i < Met.METER_COUNT; i++) {
            mMeterItems[i] = createMeterSetting(i);
            addItem(mMeterItems[i]);
        }
    }
    
    private function createIndicatorSetting(indicatorId) {
        // We need to map the ID to a String resource to be displayed
        return new WatchUi.MenuItem(
            loadResource(Ind.INDICATOR_TO_STRING_RESOURCE[indicatorId]),
            "",
            Ind.INDICATOR_NAMES[indicatorId],
            {});
    }
    
    private function createMeterSetting(meterId) {
        // We need to map the ID to a String resource to be displayed
        return new WatchUi.MenuItem(
            loadResource(Met.METER_TO_STRING_RESOURCE[meterId]),
            "",
            Met.METER_NAMES[meterId],
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
        for (var i = 0; i < Ind.INDICATOR_COUNT; i++) {
            var behaviorId = Application.getApp().getProperty(Ind.INDICATOR_NAMES[i]);
            var subLabel = loadResource(Ind.INDICATOR_BEHAVIOR_TO_STRING_RESOURCE[behaviorId]);
            mIndicatorItems[i].setSubLabel(subLabel);
        }
        
        // Meters
        for (var i = 0; i < Met.METER_COUNT; i++) {
            var behaviorId = Application.getApp().getProperty(Met.METER_NAMES[i]);
            var subLabel = loadResource(Met.METER_BEHAVIOR_TO_STRING_RESOURCE[behaviorId]);
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
        var indicatorIdx = Ind.INDICATOR_NAMES.indexOf(item.getId());
        if (indicatorIdx >= 0) {
            WatchUi.pushView(
                new Rez.Menus.SettingsMenuIndicatorSelection(),
                new SettingsMenuIndicatorMeterSelectionInputDelegate(
                    Ind.INDICATOR_NAMES[indicatorIdx],
                    Ind.INDICATOR_BEHAVIOR_NAMES),
                WatchUi.SLIDE_LEFT);
            return;
        }
        
        // Check if it's one of the meter configuration items
        var meterIdx = Met.METER_NAMES.indexOf(item.getId());
        if (meterIdx >= 0) {
            WatchUi.pushView(
                new Rez.Menus.SettingsMenuMeterSelection(),
                new SettingsMenuIndicatorMeterSelectionInputDelegate(
                    Met.METER_NAMES[meterIdx],
                    Met.METER_BEHAVIOR_NAMES),
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