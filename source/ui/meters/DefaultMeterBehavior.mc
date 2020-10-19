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
            return UiRes.gColorIndicatorActive;
        } else {
            return UiRes.gColorIndicatorInactive;
        }
    }
    
    public function isIndicating() {
        return false;
    }
    
    public function getBackgroundColor() {
        return UiRes.gColorBackground;
    }
    
    public function getActiveMeterColor() {
        return UiRes.gColorHighlights;
    }
    
    public function getInactiveMeterColor() {
        return UiRes.gColorMeterBackground;
    }
    
}