/**
 * Implements behavior for indicators. An icon must be supported, an additional
 * value can be. Override the corresponding functions in your implementation.
 * 
 * The update() function is called once every time before the indicator redraws
 * itself.
 * 
 * If partial updates are supported, wantsPartialUpdate() is called to find out
 * whether this behavior actually needs to be updated or not.
 */
class IndicatorBehavior {

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
    
    /**
     * This function is called directly before the indicator is redrawn. This is the
     * place to update state, if any.
     */
    public function update() {
    }

    ///////////////////////////////////////////////////////////////////////////////////
    // Icon Functions
    
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
     * Returns the background color. This can be different upon each invocation.
     */
    public function getBackgroundColor() {
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
    // Value Functions
    
    /**
     * Returns a string that represents the value as it should be displayed to the user.
     */
    public function getValue() {
        return null;
    }
    
    /**
     * Returns the current value font. This should always return the same font and might
     * be cached by the indicator.
     */
    public function getValueFont() {
        return null;
    }
    
    /**
     * Returns the current text color. This can be different upon each invocation.
     */
    public function getValueColor() {
        return null;
    }
    
    ///////////////////////////////////////////////////////////////////////////////////
    // Partial Update Support
    
    /**
     * If the behavior supports partial updates, this function is used to check whether
     * an update is actually required. This is ignored during regular updates.
     */
    public function wantsPartialUpdate() {
        return true;
    }
    
}