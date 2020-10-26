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
        if (index >= 0) {
            // Store the new behavior ID in the properties
            Application.getApp().setProperty(mPropertyName, index);
        } else {
            System.println("ID " + item.getId().toString() + " not found.");
        }
        
        // We're done here!
        popView(WatchUi.SLIDE_RIGHT);
    }
    
}
