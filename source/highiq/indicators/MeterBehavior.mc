/**
 * Implements behavior for a MeterIndicator. All functions except for update() must
 * be implemented, and there is no support for partial updates since meters are not
 * expected to change that quickly.
 */
class MeterBehavior {

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
     * Returns the background color. This can be different upon each invocation.
     */
    public function getBackgroundColor() {
        return null;
    }
    
    /**
     * Returns the current icon character. This may change depending on the indicator's
     * state.
     */
    public function getIconCharacter() {
        return ' ';
    }
    
    /**
     * Returns the current value to be represented by the meter.
     */
    public function getCurrValue() {
        return 0;
    }
    
    /**
     * Returns the maximum possible value that represents 100 percent.
     */
    public function getMaxValue() {
        return 1;
    }
    
    /**
     * Returns the color to be used for the filled part of the meter. This may change
     * depending on how much the meter is filled.
     */
    public function getActiveMeterColor() {
        return null;
    }
    
    /**
     * Returns the color to be used for the inactive part of the meter.
     */
    public function getInactiveMeterColor() {
        return null;
    }
    
    ///////////////////////////////////////////////////////////////////////////////////
    // Optional Functions
    
    /**
     * This function is called directly before the indicator is redrawn. This is the
     * place to update state, if any.
     */
    public function update() {
    }
    
}