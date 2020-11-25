// This is a generated file. Do not edit manually or suffer the consequences...

using Toybox.Application;
using Toybox.Graphics;

module FaceyMcWatchface {
module Themes {

// Global color variables
var gColorBackground;
var gColorDate;
var gColorAmpm;
var gColorHours;
var gColorMinutes;
var gColorSeconds;
var gColorMeterInactive;
var gColorMeterActive;
var gColorIndicatorInactive;
var gColorIndicatorActive;
var gColorIndicatorText;

// Number of themes
const THEME_COUNT = 16;
const THEME_PROPERTY = "Theme";

// Names used in all sorts of properties, settings, drawables...
const THEME_NAMES = [
    "Theme0",
    "Theme1",
    "Theme2",
    "Theme3",
    "Theme4",
    "Theme5",
    "Theme6",
    "Theme7",
    "Theme8",
    "Theme9",
    "Theme10",
    "Theme11",
    "Theme12",
    "Theme13",
    "Theme14",
    "Theme15"
];

// String resource IDs that belong to things. Use these to generate names in the UI.
const THEME_TO_STRING_RESOURCE = [
    Rez.Strings.Theme0,
    Rez.Strings.Theme1,
    Rez.Strings.Theme2,
    Rez.Strings.Theme3,
    Rez.Strings.Theme4,
    Rez.Strings.Theme5,
    Rez.Strings.Theme6,
    Rez.Strings.Theme7,
    Rez.Strings.Theme8,
    Rez.Strings.Theme9,
    Rez.Strings.Theme10,
    Rez.Strings.Theme11,
    Rez.Strings.Theme12,
    Rez.Strings.Theme13,
    Rez.Strings.Theme14,
    Rez.Strings.Theme15
];

/**
 * Sets our color variables with regard to the current theme.
 */
function updateColors() {
    switch (Application.getApp().getProperty(THEME_PROPERTY)) {
        case 0:
            gColorBackground = Graphics.COLOR_BLACK;
            gColorDate = Graphics.COLOR_LT_GRAY;
            gColorAmpm = Graphics.COLOR_LT_GRAY;
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
            gColorAmpm = Graphics.COLOR_DK_GRAY;
            gColorHours = Graphics.COLOR_BLACK;
            gColorMinutes = Graphics.COLOR_BLACK;
            gColorSeconds = Graphics.COLOR_DK_GRAY;
            gColorMeterInactive = Graphics.COLOR_LT_GRAY;
            gColorMeterActive = Graphics.COLOR_BLACK;
            gColorIndicatorInactive = Graphics.COLOR_LT_GRAY;
            gColorIndicatorActive = Graphics.COLOR_BLACK;
            gColorIndicatorText = Graphics.COLOR_BLACK;
            break;
        case 2:
            gColorBackground = Graphics.COLOR_BLACK;
            gColorDate = Graphics.COLOR_LT_GRAY;
            gColorAmpm = Graphics.COLOR_LT_GRAY;
            gColorHours = 0xff5500;
            gColorMinutes = 0xff5500;
            gColorSeconds = Graphics.COLOR_LT_GRAY;
            gColorMeterInactive = Graphics.COLOR_DK_GRAY;
            gColorMeterActive = 0xff5500;
            gColorIndicatorInactive = Graphics.COLOR_DK_GRAY;
            gColorIndicatorActive = 0xff5500;
            gColorIndicatorText = Graphics.COLOR_WHITE;
            break;
        case 3:
            gColorBackground = Graphics.COLOR_BLACK;
            gColorDate = Graphics.COLOR_LT_GRAY;
            gColorAmpm = Graphics.COLOR_LT_GRAY;
            gColorHours = 0x55FF00;
            gColorMinutes = 0x55FF00;
            gColorSeconds = Graphics.COLOR_LT_GRAY;
            gColorMeterInactive = Graphics.COLOR_DK_GRAY;
            gColorMeterActive = 0x55FF00;
            gColorIndicatorInactive = Graphics.COLOR_DK_GRAY;
            gColorIndicatorActive = 0x55FF00;
            gColorIndicatorText = Graphics.COLOR_WHITE;
            break;
        case 4:
            gColorBackground = Graphics.COLOR_BLACK;
            gColorDate = Graphics.COLOR_LT_GRAY;
            gColorAmpm = Graphics.COLOR_LT_GRAY;
            gColorHours = 0x55AAFF;
            gColorMinutes = 0x55AAFF;
            gColorSeconds = Graphics.COLOR_LT_GRAY;
            gColorMeterInactive = Graphics.COLOR_DK_GRAY;
            gColorMeterActive = 0x55AAFF;
            gColorIndicatorInactive = Graphics.COLOR_DK_GRAY;
            gColorIndicatorActive = 0x55AAFF;
            gColorIndicatorText = Graphics.COLOR_WHITE;
            break;
        case 5:
            gColorBackground = Graphics.COLOR_BLACK;
            gColorDate = Graphics.COLOR_LT_GRAY;
            gColorAmpm = Graphics.COLOR_LT_GRAY;
            gColorHours = 0xFFFF55;
            gColorMinutes = 0xFFFF55;
            gColorSeconds = Graphics.COLOR_LT_GRAY;
            gColorMeterInactive = Graphics.COLOR_DK_GRAY;
            gColorMeterActive = 0xFFFF55;
            gColorIndicatorInactive = Graphics.COLOR_DK_GRAY;
            gColorIndicatorActive = 0xFFFF55;
            gColorIndicatorText = Graphics.COLOR_WHITE;
            break;
        case 6:
            gColorBackground = Graphics.COLOR_BLACK;
            gColorDate = Graphics.COLOR_LT_GRAY;
            gColorAmpm = Graphics.COLOR_LT_GRAY;
            gColorHours = 0xFF00AA;
            gColorMinutes = 0xFF00AA;
            gColorSeconds = Graphics.COLOR_LT_GRAY;
            gColorMeterInactive = Graphics.COLOR_DK_GRAY;
            gColorMeterActive = 0xFF00AA;
            gColorIndicatorInactive = Graphics.COLOR_DK_GRAY;
            gColorIndicatorActive = 0xFF00AA;
            gColorIndicatorText = Graphics.COLOR_WHITE;
            break;
        case 7:
            gColorBackground = Graphics.COLOR_BLACK;
            gColorDate = Graphics.COLOR_LT_GRAY;
            gColorAmpm = Graphics.COLOR_LT_GRAY;
            gColorHours = 0x00FFFF;
            gColorMinutes = 0x00FFFF;
            gColorSeconds = Graphics.COLOR_LT_GRAY;
            gColorMeterInactive = Graphics.COLOR_DK_GRAY;
            gColorMeterActive = 0x00FFFF;
            gColorIndicatorInactive = Graphics.COLOR_DK_GRAY;
            gColorIndicatorActive = 0x00FFFF;
            gColorIndicatorText = Graphics.COLOR_WHITE;
            break;
        case 8:
            gColorBackground = 0xFF55AA;
            gColorDate = 0xAA0055;
            gColorAmpm = 0xAA0055;
            gColorHours = Graphics.COLOR_WHITE;
            gColorMinutes = Graphics.COLOR_WHITE;
            gColorSeconds = 0xAA0055;
            gColorMeterInactive = 0xAA0055;
            gColorMeterActive = Graphics.COLOR_WHITE;
            gColorIndicatorInactive = 0xAA0055;
            gColorIndicatorActive = Graphics.COLOR_WHITE;
            gColorIndicatorText = Graphics.COLOR_WHITE;
            break;
        case 9:
            gColorBackground = Graphics.COLOR_WHITE;
            gColorDate = Graphics.COLOR_DK_GRAY;
            gColorAmpm = Graphics.COLOR_DK_GRAY;
            gColorHours = 0xff0000;
            gColorMinutes = 0xff0000;
            gColorSeconds = Graphics.COLOR_DK_GRAY;
            gColorMeterInactive = Graphics.COLOR_LT_GRAY;
            gColorMeterActive = 0xff0000;
            gColorIndicatorInactive = Graphics.COLOR_LT_GRAY;
            gColorIndicatorActive = 0xff0000;
            gColorIndicatorText = Graphics.COLOR_BLACK;
            break;
        case 10:
            gColorBackground = Graphics.COLOR_WHITE;
            gColorDate = Graphics.COLOR_DK_GRAY;
            gColorAmpm = Graphics.COLOR_DK_GRAY;
            gColorHours = 0x00aa00;
            gColorMinutes = 0x00aa00;
            gColorSeconds = Graphics.COLOR_DK_GRAY;
            gColorMeterInactive = Graphics.COLOR_LT_GRAY;
            gColorMeterActive = 0x00aa00;
            gColorIndicatorInactive = Graphics.COLOR_LT_GRAY;
            gColorIndicatorActive = 0x00aa00;
            gColorIndicatorText = Graphics.COLOR_BLACK;
            break;
        case 11:
            gColorBackground = Graphics.COLOR_WHITE;
            gColorDate = Graphics.COLOR_DK_GRAY;
            gColorAmpm = Graphics.COLOR_DK_GRAY;
            gColorHours = 0x0000aa;
            gColorMinutes = 0x0000aa;
            gColorSeconds = Graphics.COLOR_DK_GRAY;
            gColorMeterInactive = Graphics.COLOR_LT_GRAY;
            gColorMeterActive = 0x0000aa;
            gColorIndicatorInactive = Graphics.COLOR_LT_GRAY;
            gColorIndicatorActive = 0x0000aa;
            gColorIndicatorText = Graphics.COLOR_BLACK;
            break;
        case 12:
            gColorBackground = Graphics.COLOR_WHITE;
            gColorDate = Graphics.COLOR_DK_GRAY;
            gColorAmpm = Graphics.COLOR_DK_GRAY;
            gColorHours = 0xffaa00;
            gColorMinutes = 0xffaa00;
            gColorSeconds = Graphics.COLOR_DK_GRAY;
            gColorMeterInactive = Graphics.COLOR_LT_GRAY;
            gColorMeterActive = 0xffaa00;
            gColorIndicatorInactive = Graphics.COLOR_LT_GRAY;
            gColorIndicatorActive = 0xffaa00;
            gColorIndicatorText = Graphics.COLOR_BLACK;
            break;
        case 13:
            gColorBackground = Graphics.COLOR_WHITE;
            gColorDate = Graphics.COLOR_DK_GRAY;
            gColorAmpm = Graphics.COLOR_DK_GRAY;
            gColorHours = 0xff00aa;
            gColorMinutes = 0xff00aa;
            gColorSeconds = Graphics.COLOR_DK_GRAY;
            gColorMeterInactive = Graphics.COLOR_LT_GRAY;
            gColorMeterActive = 0xff00aa;
            gColorIndicatorInactive = Graphics.COLOR_LT_GRAY;
            gColorIndicatorActive = 0xff00aa;
            gColorIndicatorText = Graphics.COLOR_BLACK;
            break;
        case 14:
            gColorBackground = Graphics.COLOR_WHITE;
            gColorDate = Graphics.COLOR_DK_GRAY;
            gColorAmpm = Graphics.COLOR_DK_GRAY;
            gColorHours = 0x00aaaa;
            gColorMinutes = 0x00aaaa;
            gColorSeconds = Graphics.COLOR_DK_GRAY;
            gColorMeterInactive = Graphics.COLOR_LT_GRAY;
            gColorMeterActive = 0x00aaaa;
            gColorIndicatorInactive = Graphics.COLOR_LT_GRAY;
            gColorIndicatorActive = 0x00aaaa;
            gColorIndicatorText = Graphics.COLOR_BLACK;
            break;
        case 15:
            gColorBackground = 0xAA0055;
            gColorDate = 0xFF55AA;
            gColorAmpm = 0xFF55AA;
            gColorHours = Graphics.COLOR_WHITE;
            gColorMinutes = Graphics.COLOR_WHITE;
            gColorSeconds = 0xFF55AA;
            gColorMeterInactive = 0xFF55AA;
            gColorMeterActive = Graphics.COLOR_WHITE;
            gColorIndicatorInactive = 0xFF55AA;
            gColorIndicatorActive = Graphics.COLOR_WHITE;
            gColorIndicatorText = Graphics.COLOR_WHITE;
            break;
        default:
            // Reset invalid theme number and call this again
            Application.getApp().setProperty(THEME_PROPERTY, 0);
            updateColors();
    }
}

} }
