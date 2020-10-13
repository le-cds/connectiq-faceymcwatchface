/**
 * Implements several of the MeterBehavior functions with default values. Adds
 * another function, isIndicating(), to check which icon color to use.
 */
class DefaultMeterBehavior {

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
    
    public function getActiveMeterColor() {
        return gColorHighlights;
    }
    
    public function getInactiveMeterColor() {
        return gColorMeterBackground;
    }
    
}