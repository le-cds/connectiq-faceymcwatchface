using FaceyMcWatchface.Themes;
using FaceyMcWatchface.UiResources as UiRes;

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
        return UiRes.gSymbolsFont;
    }
    
    public function getIconColor() {
        if (isIndicating()) {
            return Themes.gColorIndicatorActive;
        } else {
            return Themes.gColorIndicatorInactive;
        }
    }
    
    public function isIndicating() {
        return false;
    }
    
    public function getBackgroundColor() {
        return Themes.gColorBackground;
    }
    
    public function getIconSize() {
        return 16;
    }
    
    ///////////////////////////////////////////////////////////////////////////////////
    // Value Functions
    
    public function getValueFont() {
        return UiRes.gIndicatorFont;
    }
    
    public function getValueColor() {
        return Themes.gColorIndicatorText;
    }
    
}