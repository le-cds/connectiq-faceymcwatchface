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

} } // Modules
