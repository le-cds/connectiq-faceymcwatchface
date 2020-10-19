using Toybox.Graphics;
using Toybox.WatchUi;

module FaceyMcWatchface {
module UiResources {

////////////////////////////////////////////////////////////////////////////////
// Fonts

// These are all the fonts we need. They won't change, so they're loaded
// directly.

var gDateFont = WatchUi.loadResource(Rez.Fonts.DateFont);

var gHoursFont = WatchUi.loadResource(Rez.Fonts.HoursFont);
var gMinutesFont = WatchUi.loadResource(Rez.Fonts.MinutesFont);
var gDetailsFont = WatchUi.loadResource(Rez.Fonts.SecondsFont);

var gIndicatorFont = WatchUi.loadResource(Rez.Fonts.IndicatorFont);

var gSymbolsFont = WatchUi.loadResource(Rez.Fonts.SymbolsFont);


////////////////////////////////////////////////////////////////////////////////
// Colors

// These are all of the colors we need. They may change, and are thus
// initialised by the function below.

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
 * Sets our colour constants. This could at some point implement
 * different themes.
 */
function updateColors() {
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

} } // Modules
