/**
 * Implements behavior for an OnOffIndicator. To get an indicator which displays state
 * on each full redraw, implement the following functions:
 *
 * - isOn()
 * - getIconCharacter()
 * - getIconFont()
 *
 * If the default return values are not okay, clients may want to implement these
 * functions as well:
 * 
 * - getIconSize()
 * 
 * Implement the other functions as well to add support for partial updates.
 */
class OnOffBehavior {

    ///////////////////////////////////////////////////////////////////////////////////
    // Necessary Functions
    
    /**
     * Returns whether or not the indicator should light up. This function should be
     * implemented by subclasses.
     */
    public function isOn() {
        return false;
    }
    
    /**
     * Returns the current icon font. This should always return the same font and might
     * be cached by the indicator.
     */
    public function getIconFont() {
        return null;
    }
    
    /**
     * Returns the size of icons, e.g., 16 for a 16x16 pixel icon. This should always
     * return the same font and might be cached by the indicator.
     * 
     * The default implementation returns 16.
     */
    public function getIconSize() {
        return 16;
    }
    
    /**
     * Returns the current icon character. This may change depending on the indicator's
     * state.
     */
    public function getIconCharacter() {
        return ' ';
    }
    
    ///////////////////////////////////////////////////////////////////////////////////
    // Partial Update Support

    /**
     * Returns whether or not this indicator updates during partial updates. By default,
     * this is not the case, which will cause the indicator to update only once per
     * minute or when the watchface is completely redrawn anyway. Override and return
     * true only if the indicator displays information that should be updated more often
     * than that.
     */
    public function supportsPartialUpdate() {
        return false;
    }
    
    /**
     * If the indicator supports partial updates, this function is used to check whether
     * an update is actually required. This is ignored during regular updates.
     */
    public function needsUpdate() {
        return true;
    }
    
}