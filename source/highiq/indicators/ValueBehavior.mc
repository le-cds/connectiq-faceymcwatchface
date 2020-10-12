/**
 * Implements behavior for a ValueIndicator. Everything true about OnOffBehavior is
 * still true here. The following functions need to be implemented:
 *
 * - getValue()
 * - getValueFont()
 * - getValueColor()
 */
class ValueBehavior extends IconBehavior {

    public function initialize(supportsPartialUpdates) {
        IconBehavior.initialize(supportsPartialUpdates);
    }

    ///////////////////////////////////////////////////////////////////////////////////
    // Necessary Functions
    
    /**
     * Returns a string that represents the value as it should be displayed to the user.
     */
    public function getValue() {
        return "";
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
    
}