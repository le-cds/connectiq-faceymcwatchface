/* Utility functions for implementing indicators. */

/**
 * Turns a number into a short string representation. Numbers are shortened
 * at most two digits and a decimal or three digits without decimal, plus
 * an additional "k" or "m".
 */
function toShortNumberString(number) {
    if (number < 1000) {
        // This is not actually a string, but it'll do for what we want to
        // do with it
        return number;
    }
    
    // Prepare what we will display
    var quantityChar = "";
    
    if (number >= 1000000) {
        number /= 1000000.0;
        quantityChar = "M";
    } else if (number >= 1000) {
        number /= 1000.0;
        quantityChar = "k";
    }
    
    // We'll have numbers < 1000 now but we only want to display decimals if
    // we're also < 100
    if (number < 100) {
        return number.format("%.1f") + quantityChar;
    } else {
        return number.format("%.0f") + quantityChar;
    }
}
