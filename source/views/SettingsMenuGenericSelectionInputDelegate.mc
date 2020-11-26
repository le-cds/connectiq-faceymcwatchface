using Toybox.WatchUi;

/**
 * Input delegate for generated selection menus.
 */
class SettingsMenuGenericSelectionInputDelegate extends WatchUi.Menu2InputDelegate {

    /** Name of the property we'll set. */
    private var mPropertyName;
    /** Array with all possible property values. */
    private var mPropertyValuesArray;

    function initialize(propertyName, valuesArray) {
        Menu2InputDelegate.initialize();
        
        mPropertyName = propertyName;
        mPropertyValuesArray = valuesArray;
    }

    public function onSelect(item) {
        // Find the index of the value in the array of possible values
        var index = mPropertyValuesArray.indexOf(item.getId().toString());
        
        // Store the new behavior ID in the properties, even if the indexOf
        // method returned -1.
        Application.getApp().setProperty(mPropertyName, index);
        
        // We're done here!
        popView(WatchUi.SLIDE_RIGHT);
    }
    
}
