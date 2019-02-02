using Toybox.Graphics;

/* Contains all colour definitions. They have to be initialized by the view by
 * calling initializeColours(). They cannot be initialized directly since that
 * will prevent the background service to run, which attempts to initialize them
 * but doesn't have the Graphics module available.
 */

var gColorBackground;
var gColorHighlights;

var gColorDate;
var gColorHours;
var gColorMinutes;
var gColorSeconds;

var gColorMeterBackground;
var gColorMeterNotReached;
var gColorMeterReached;

var gColorIndicatorInactive;
var gColorIndicatorActive;
var gColorIndicatorText;

/**
 * Initializes the colour constants. This could at some point implement
 * different themes.
 */
function initializeColours() {
    gColorBackground = Graphics.COLOR_BLACK;
    gColorHighlights = Graphics.COLOR_WHITE;

    gColorDate = Graphics.COLOR_LT_GRAY;
    gColorHours = Graphics.COLOR_WHITE;
    gColorMinutes = Graphics.COLOR_WHITE;
    gColorSeconds = Graphics.COLOR_LT_GRAY;

    gColorMeterBackground = Graphics.COLOR_DK_GRAY;
    gColorMeterNotReached = Graphics.COLOR_DK_GRAY;
    gColorMeterReached = gColorHighlights;

    gColorIndicatorInactive = Graphics.COLOR_DK_GRAY;
    gColorIndicatorActive = gColorHighlights;
    gColorIndicatorText = Graphics.COLOR_WHITE;
}
