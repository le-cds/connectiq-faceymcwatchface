using Toybox.System;
using Toybox.Time.Gregorian;
using Toybox.WatchUi;

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

    // Clip rect to quickly redraw the seconds in low-power mode. The Y coordinate
    // is different from mSecondsY due to the way font coordinates seem to work.
    private var mSecondsClipY;
    private var mSecondsClipWidth;
    private var mSecondsClipHeight;

    /**
     * Initialize the whole thing.
     */
    function initialize(params) {
        Drawable.initialize(params);

        // Initialize from parameters
        mTimeY = params[:timeY];
        mDetailsY = mTimeY + params[:detailsOffsetY];
        mSecondsClipY = mDetailsY + params[:secondsClipOffsetY];
        mSecondsClipHeight = params[:secondsClipHeight];
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
        drawSeconds(dc, false);
    }

    /**
     * Compute the X coordinates of the time components.
     */
    function initializeCoordinates(dc) {
        // Where to draw the colon
        mColonMidX = dc.getWidth() / 2;
        var halfColonWidth = dc.getTextWidthInPixels(":", gHoursFont) / 2;

        // Where to draw the hours and minutes
        mHoursRightX = mColonMidX - halfColonWidth;
        mMinutesX = mColonMidX + halfColonWidth;

        // Where to draw the seconds
        var minutesWidth = dc.getTextWidthInPixels("00", gMinutesFont);
        mSecondsX = mMinutesX + minutesWidth  + 4;

        // Where to draw the AM/PM indicator
        var hourWidth = dc.getTextWidthInPixels("00", gHoursFont);
        mAmPmRightX = mHoursRightX - hourWidth - 4;

        // Width of the clip rectangle used to draw seconds during partial updates
        mSecondsClipWidth = dc.getTextWidthInPixels("00", gDetailsFont);
    }

    function drawEverythingExceptSeconds(dc) {
        var time = System.getClockTime();

        // Retrieve the basic time values
        var hours = time.hour;
        var minutes = time.min;
        var amPm = "";

        // If the clock is not in 24-hour mode, we may need to adjust the hours
        // and add an am/pm indicator
        if (!System.getDeviceSettings().is24Hour) {
            if (hours >= 12) {
                amPm = "pm";

                // Noon needs to be shown as 12, not 0
                if (hours > 12) {
                    hours -= 12;
                }

            } else {
                amPm = "am";

                // Midnight must be 12, not 0
                if (hours == 0) {
                    hours = 12;
                }
            }
        }

        // Actually draw stuff
        dc.setColor(gColorHours, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            mHoursRightX,
            mTimeY,
            gHoursFont,
            hours.format("%02d"),
            Graphics.TEXT_JUSTIFY_RIGHT
        );

        dc.setColor(gColorMinutes, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            mColonMidX,
            mTimeY,
            gHoursFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            mMinutesX,
            mTimeY,
            gMinutesFont,
            minutes.format("%02d"),
            Graphics.TEXT_JUSTIFY_LEFT
        );

        dc.setColor(gColorSeconds, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            mAmPmRightX,
            mDetailsY,
            gDetailsFont,
            amPm,
            Graphics.TEXT_JUSTIFY_RIGHT
        );
    }

    /**
     * Draws the seconds. If this is called during a partial update we reset the background
     * before drawing the seconds so that they don't overlap the old seconds.
     */
    function drawSeconds(dc, isPartialUpdate) {
        var seconds = System.getClockTime().sec.format("%02d");

        if (isPartialUpdate) {
            // Clear the last seconds displayed
            dc.setClip(
                mSecondsX,
                mSecondsClipY,
                mSecondsClipWidth,
                mSecondsClipHeight
            );

            //dc.setColor(gColorSeconds, Graphics.COLOR_RED);
            dc.setColor(gColorSeconds, gColorBackground);
            dc.clear();
        }

        dc.setColor(gColorSeconds, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            mSecondsX,
            mDetailsY,
            gDetailsFont,
            seconds,
            Graphics.TEXT_JUSTIFY_LEFT
        );
    }

}