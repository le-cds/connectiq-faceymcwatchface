using Toybox.WatchUi;

/* Contains all font definitions. They have to be initialized by the view by
 * calling initializeFonts(). They cannot be initialized directly since the
 * background service doesn't actually need them.
 */

var gDateFont;

var gHoursFont;
var gMinutesFont;
var gDetailsFont;

var gIndicatorFont;

var gSymbolsFont;

/**
 * Initializes the font constants.
 */
function initializeFonts() {
    gDateFont = WatchUi.loadResource(Rez.Fonts.DateFont);

    gHoursFont = WatchUi.loadResource(Rez.Fonts.HoursFont);
    gMinutesFont = WatchUi.loadResource(Rez.Fonts.MinutesFont);
    gDetailsFont = WatchUi.loadResource(Rez.Fonts.SecondsFont);

    gIndicatorFont = WatchUi.loadResource(Rez.Fonts.IndicatorFont);

    gSymbolsFont = WatchUi.loadResource(Rez.Fonts.SymbolsFont);
}
