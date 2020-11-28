using Toybox.System;
using Toybox.Time.Gregorian;
using Toybox.WatchUi;
using FaceyMcWatchface.Themes;
using FaceyMcWatchface.UiResources as UiRes;

/**
 * Displays the date line, centered at the y coordinate supplied through the layout.
 *
 * This code is based on code from the Crystal watch face, which can be found at:
 * https://github.com/warmsound/crystal-face
 */
class TimeLine extends WatchUi.Drawable {

    // The Y coordinate to draw the time at
    private var mTimeY;
    // The Y coordinate to draw the seconds and the AM/PM indicator at
    private var mDetailsY;

    // Whether we've already computed the X coordinates
    private var mCoordinatesInitialized = false;
    // The X coordinate to draw the hours at (right-aligned)
    private var mHoursRightX;
    // The X coordinate to draw the colon at (centered)
    private var mColonMidX;
    // The X coordinate to draw the minutes at
    private var mMinutesX;
    // The X coordinate to draw the seconds at
    private var mSecondsX;
    // The X coordinate to draw the am/pm indicator at (right-aligned)
    private var mAmPmRightX;

    // Size of the clip rect to quickly redraw the seconds during partial updates.
    private var mSecondsClipDimensions;

    /**
     * Initialize the whole thing.
     */
    function initialize(params) {
        Drawable.initialize(params);

        // Initialize from parameters
        mTimeY = params[:timeY];
        mDetailsY = mTimeY + params[:detailsOffsetY];
    }

    /**
     * Updates the date. If it has changed, draws the date onto the device context.
     */
    function draw(dc) {
        // We need to know where to draw the different parts of the time
        if (!mCoordinatesInitialized) {
            initializeCoordinates(dc);
            mCoordinatesInitialized = true;
        }

        drawEverythingExceptSeconds(dc);
        drawSeconds(dc);
    }

    /**
     * Compute the X coordinates of the time components.
     */
    function initializeCoordinates(dc) {
        // Where to draw the colon
        mColonMidX = dc.getWidth() / 2;
        var halfColonWidth = dc.getTextWidthInPixels(":", UiRes.gHoursFont) / 2;

        // Where to draw the hours and minutes
        mHoursRightX = mColonMidX - halfColonWidth;
        mMinutesX = mColonMidX + halfColonWidth;

        // Where to draw the seconds
        var minutesWidth = dc.getTextWidthInPixels("00", UiRes.gMinutesFont);
        mSecondsX = mMinutesX + minutesWidth  + 4;

        // Where to draw the AM/PM indicator
        var hourWidth = dc.getTextWidthInPixels("00", UiRes.gHoursFont);
        mAmPmRightX = mHoursRightX - hourWidth - 4;

        // Width of the clip rectangle used to draw seconds during partial updates
        mSecondsClipDimensions = dc.getTextDimensions("00", UiRes.gDetailsFont);
    }

    function drawEverythingExceptSeconds(dc) {
        var time = System.getClockTime();
        var displayTime = displayableTime(time.hour, time.min, time.sec);

        // Actually draw stuff
        dc.setColor(Themes.gColorHours, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            mHoursRightX,
            mTimeY,
            UiRes.gHoursFont,
            displayTime[:hour],
            Graphics.TEXT_JUSTIFY_RIGHT
        );

        dc.setColor(Themes.gColorMinutes, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            mColonMidX,
            mTimeY,
            UiRes.gHoursFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            mMinutesX,
            mTimeY,
            UiRes.gMinutesFont,
            displayTime[:minute],
            Graphics.TEXT_JUSTIFY_LEFT
        );

        dc.setColor(Themes.gColorAmpm, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            mAmPmRightX,
            mDetailsY,
            UiRes.gDetailsFont,
            displayTime[:ampm],
            Graphics.TEXT_JUSTIFY_RIGHT
        );
    }

    /**
     * Draws the seconds. This is also called during partial updates.
     */
    function drawSeconds(dc) {
        var seconds = System.getClockTime().sec.format("%02d");

        // Restrict the area we're dirtying (speeds up partial updates)
        dc.setClip(
            mSecondsX,
            mDetailsY,
            mSecondsClipDimensions[0],
            mSecondsClipDimensions[1]
        );
        
        dc.setColor(Themes.gColorSeconds, Themes.gColorBackground);
        dc.drawText(
            mSecondsX,
            mDetailsY,
            UiRes.gDetailsFont,
            seconds,
            Graphics.TEXT_JUSTIFY_LEFT
        );
        
        dc.clearClip();
    }

}