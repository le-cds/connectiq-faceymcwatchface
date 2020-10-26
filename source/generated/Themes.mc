// This is a generated file. Do not edit manually or suffer the consequences...

using Toybox.Application;
using Toybox.Graphics;

module FaceyMcWatchface {
module Themes {

// Global color variables
var gColorBackground;
var gColorDate;
var gColorHours;
var gColorMinutes;
var gColorSeconds;
var gColorMeterInactive;
var gColorMeterActive;
var gColorIndicatorInactive;
var gColorIndicatorActive;
var gColorIndicatorText;

// Number of themes
const THEME_COUNT = 2;
const THEME_PROPERTY = "Theme";

// Names used in all sorts of properties, settings, drawables...
const THEME_NAMES = [
    "Theme0",
    "Theme1"
];

// String resource IDs that belong to things. Use these to generate names in the UI.
const THEME_TO_STRING_RESOURCE = [
    Rez.Strings.Theme0,
    Rez.Strings.Theme1
];

/**
 * Sets our color variables with regard to the current theme.
 */
function updateColors() {
    switch (Application.getApp().getProperty(THEME_PROPERTY)) {
        case 0:
            gColorBackground = Graphics.COLOR_BLACK;
            gColorDate = Graphics.COLOR_LT_GRAY;
            gColorHours = Graphics.COLOR_WHITE;
            gColorMinutes = Graphics.COLOR_WHITE;
            gColorSeconds = Graphics.COLOR_LT_GRAY;
            gColorMeterInactive = Graphics.COLOR_DK_GRAY;
            gColorMeterActive = Graphics.COLOR_WHITE;
            gColorIndicatorInactive = Graphics.COLOR_DK_GRAY;
            gColorIndicatorActive = Graphics.COLOR_WHITE;
            gColorIndicatorText = Graphics.COLOR_WHITE;
            break;
        case 1:
            gColorBackground = Graphics.COLOR_WHITE;
            gColorDate = Graphics.COLOR_DK_GRAY;
            gColorHours = Graphics.COLOR_BLACK;
            gColorMinutes = Graphics.COLOR_BLACK;
            gColorSeconds = Graphics.COLOR_DK_GRAY;
            gColorMeterInactive = Graphics.COLOR_LT_GRAY;
            gColorMeterActive = Graphics.COLOR_BLACK;
            gColorIndicatorInactive = Graphics.COLOR_LT_GRAY;
            gColorIndicatorActive = Graphics.COLOR_BLACK;
            gColorIndicatorText = Graphics.COLOR_BLACK;
            break;
        default:
            // Reset invalid theme number and call this again
            Application.getApp().setProperty(THEME_PROPERTY, 0);
            updateColors();
    }
}

} }
