/**
 * Implements several of the IndicatorBehavior functions with default values. Adds
 * another function, isIndicating(), to check which icon color to use.
 */
class DefaultIndicatorBehavior extends IndicatorBehavior {
    
    public function initialize(supportsPartialUpdates) {
        IndicatorBehavior.initialize(supportsPartialUpdates);
    }

    ///////////////////////////////////////////////////////////////////////////////////
    // Icon Functions
    
    public function getIconFont() {
        return gSymbolsFont;
    }
    
    public function getIconColor() {
        if (isIndicating()) {
            return gColorIndicatorActive;
        } else {
            return gColorIndicatorInactive;
        }
    }
    
    public function isIndicating() {
        return false;
    }
    
    public function getBackgroundColor() {
        return gColorBackground;
    }
    
    public function getIconSize() {
        return 16;
    }
    
    ///////////////////////////////////////////////////////////////////////////////////
    // Value Functions
    
    public function getValueFont() {
        return gIndicatorFont;
    }
    
    public function getValueColor() {
        return gColorIndicatorText;
    }
    
}