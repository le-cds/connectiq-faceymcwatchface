using Toybox.System;
using Toybox.WatchUi;

/**
 * Displays indicators about the number of notifications, the battery status, and the
 * number of active alarms. The number of notifications is updated on every partial
 * update while the others are only updated on each full redraw. This is sensible since
 * the battery status doesn't change as often and configuring or silencing an alarm is
 * followed by a full redraw anyway. The number of notifications is only really redrawn
 * if it has changed since the last update.
 *
 * This code is based on code from the Crystal watch face, which can be found at:
 * https://github.com/warmsound/crystal-face
 */
class ValueIndicators extends WatchUi.Drawable {

    // The assumed width / height of each symbol
    private const SYMBOL_SIZE = 16;
    // Half of SYMBOL_SIZE.
    private const HALF_SYMBOL_SIZE = SYMBOL_SIZE / 2;

    // The characters used for the different symbols
    private const SYMBOL_NOTIFICATIONS = "C";
    private const SYMBOL_ALARMS = "D";

    // I wasn't able to find out how (and if) character arithmetic works, so this
    // array is a workaround
    private const SYMBOL_BATTERY = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];

    // Y coordinate of the symbols.
    private var mY;
    // Y coordinate of the text.
    private var mTextY;
    // X coordinate of the left icon's center.
    private var mLeftX;
    // X coordinate of the middle icon's center.
    private var mMidX;
    // X coordinate of the right icon's center.
    private var mRightX;

    // Last known number of notifications. Used to minimize redrawing.
    private var mNotifications;

    /**
     * Initialize the whole thing.
     */
    function initialize(params) {
        Drawable.initialize(params);

        // Initialize from parameters
        mY = params[:y];
        mTextY = mY + SYMBOL_SIZE - 2;

        var distance = params[:distance];

        mMidX = System.getDeviceSettings().screenWidth / 2;
        mLeftX = mMidX - distance - SYMBOL_SIZE;
        mRightX = mMidX + distance + SYMBOL_SIZE;
    }

    /**
     * Updates the date. If it has changed, draws the date onto the device context.
     */
    function draw(dc) {
        var settings = System.getDeviceSettings();

        // Notifications indicator
        drawNotifications(dc, false);

        // Compute in which battery percentile we are:
        //    0% to 10% -> 0
        //   11% to 20% -> 1
        //   ...
        var batt = System.getSystemStats().battery.toNumber();
        var battPercentile = (batt - 1) / 10;
        if (battPercentile < 0) {
            battPercentile = 0;
        }

        // Battery indicator (draw as active if battery is below 20%)
        drawIndicator(
            dc,
            mMidX,
            SYMBOL_BATTERY[battPercentile],
            batt.format("%d") + "%",
            batt < 20);

        // Alarms indicator
        var alarms = System.getDeviceSettings().alarmCount;
        drawIndicator(
            dc,
            mRightX,
            SYMBOL_ALARMS,
            alarms.format("%d"),
            alarms > 0);
    }

    /**
     * Draw the Notifications indicator. If this is called during a partial update,
     * we only draw something if the number of notifications has in fact changed.
     */
    function drawNotifications(dc, isPartialUpdate) {
        var notifications = System.getDeviceSettings().notificationCount;

        if (isPartialUpdate) {
            // Draw the indicator only if its state has changed
            if (notifications != mNotifications) {
                // Reset area of symbol and text (this assumes that the text will never
                // grow wider than the symbol; we'll see whether that will hold up...)
                dc.setClip(
                    mLeftX - HALF_SYMBOL_SIZE,
                    mY,
                    SYMBOL_SIZE,
                    SYMBOL_SIZE + 20
                );

                dc.setColor(gColorHighlights, gColorBackground);
                dc.clear();

                drawIndicator(dc, mLeftX, SYMBOL_NOTIFICATIONS, notifications.format("%d"), notifications > 0);
            }

        } else {
            // It's not a partial update, so simply draw the indicator
            drawIndicator(dc, mLeftX, SYMBOL_NOTIFICATIONS, notifications.format("%d"), notifications > 0);
        }

        mNotifications = notifications;
    }

    /**
     * Draws the given indicator glyph at the given coordinates. The color will depend on
     * whether the indicator is considered active or not.
     */
    function drawIndicator(dc, x, glyph, text, active) {
        if (active) {
            dc.setColor(gColorIndicatorActive, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(gColorIndicatorInactive, Graphics.COLOR_TRANSPARENT);
        }

        // Draw the symbol
        //dc.fillRectangle(x - HALF_SYMBOL_SIZE, mY, SYMBOL_SIZE, SYMBOL_SIZE);
        dc.drawText(
            x,
            mY,
            gSymbolsFont,
            glyph,
            Graphics.TEXT_JUSTIFY_CENTER
        );

        // Draw the text underneath
        dc.setColor(gColorIndicatorText, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x,
            mTextY,
            gIndicatorFont,
            text,
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

}