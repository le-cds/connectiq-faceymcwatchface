using FaceyMcWatchface.Themes;
using FaceyMcWatchface.UiResources as UiRes;

/**
 * Implements several of the MeterBehavior functions with default values. Adds
 * another function, isIndicating(), to check which icon color to use.
 */
class DefaultMeterBehavior extends MeterBehavior {

    public function initialize() {
        MeterBehavior.initialize();
    }

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
    
    public function getActiveMeterColor() {
        return Themes.gColorMeterActive;
    }
    
    public function getInactiveMeterColor() {
        return Themes.gColorMeterInactive;
    }
    
}