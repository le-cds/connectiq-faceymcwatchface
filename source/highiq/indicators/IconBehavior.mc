/**
 * Implements behavior for an IconIndicator. To get an indicator which displays state
 * on each full redraw, implement the following functions:
 *
 * - initialize() (subclasses need to indicate whether or not they support partial updates)
 * - getIconFont()
 * - getIconColor()
 * - getIconCharacter()
 *
 * Clients may want to implement these functions as well:
 * 
 * - getIconSize()
 * - update()
 * 
 * Implement the other functions as well to add support for partial updates. If a
 * behavior supports partial updates, needsUpdate() will be called on every partial
 * update cycle.
 */
class IconBehavior {

    /** Whether this behavior supports partial updates. */
    private var mSupportsPartialUpdates;
    
    public function initialize(supportsPartialUpdates) {
        mSupportsPartialUpdates = supportsPartialUpdates;
    }

    /**
     * Returns whether or not this behavior supports partial updates.
     */
    public function supportsPartialUpdate() {
        return false;
    }

    ///////////////////////////////////////////////////////////////////////////////////
    // Necessary Functions
    
    /**
     * Returns the current icon font. This should always return the same font and might
     * be cached by the indicator.
     */
    public function getIconFont() {
        return null;
    }
    
    /**
     * Returns the current icon color. This can be different upon each invocation.
     */
    public function getIconColor() {
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
     * If the behavior supports partial updates, this function is used to check whether
     * an update is actually required. This is ignored during regular updates.
     */
    public function needsUpdate() {
        return true;
    }
    
    /**
     * This function is called directly before the indicator is redrawn. This is the
     * place to update state, if any.
     */
    public function update() {
    }
    
}