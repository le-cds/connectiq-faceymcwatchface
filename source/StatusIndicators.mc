using Toybox.System;
using Toybox.WatchUi;

/**
 * Displays bluetooth and do-not-disturb indicators, which are simple on-off symbols. The
 * Bluetooth state can be updated each seoncd and only triggers drawing operations if the
 * state has, in fact, changed. This is not necessary for the DND state since changeing that
 * involves leaving and re-entering the watch face, causing it to be completely redrawn
 * anyway.
 *
 * This code is based on code from the Crystal watch face, which can be found at:
 * https://github.com/warmsound/crystal-face
 */
class StatusIndicators extends WatchUi.Drawable {

    // The assumed width / height of each symbol
    private const SYMBOL_SIZE = 16;

    // The characters used for the different symbols
    private const SYMBOL_BLUETOOTH = "A";
    private const SYMBOL_DND = "B";

    // Y coordinate of the two symbols.
    private var mY;
    // X coordinate of the left icon's left border.
    private var mLeftX;
    // X coordinate of the right icon's left border.
    private var mRightX;

    // Last known state of Bluetooth connection. Used to minimize redrawing
    private var mPhoneConnected;

    /**
     * Initialize the whole thing.
     */
    function initialize(params) {
        Drawable.initialize(params);

        // Initialize from parameters
        mY = params[:y];

        var center = System.getDeviceSettings().screenWidth / 2;
        var halfDistance = params[:distance] / 2;
        var halfSymbolSize = SYMBOL_SIZE / 2;

        mLeftX = center - halfDistance - SYMBOL_SIZE;
        mRightX = center + halfDistance;
    }

    /**
     * Updates the date. If it has changed, draws the date onto the device context.
     */
    function draw(dc) {
        var settings = System.getDeviceSettings();

        drawBluetooth(dc, false);
        drawIndicator(dc, mRightX, SYMBOL_DND, settings.doNotDisturb);
    }

    /**
     * Draw the Bluetooth indicator. If this is called during a partial update,
     * we only draw something if the Bluetooth state has in fact changed.
     */
    function drawBluetooth(dc, isPartialUpdate) {
        var connected = System.getDeviceSettings().phoneConnected;

        if (isPartialUpdate) {
            // Draw the indicator only if its state has changed
            if (connected != mPhoneConnected) {
                // Reset the symbol's area
                dc.setClip(
                    mLeftX,
                    mY,
                    SYMBOL_SIZE,
                    SYMBOL_SIZE
                );

                dc.setColor(gColorHighlights, gColorBackground);
                dc.clear();

                drawIndicator(dc, mLeftX, SYMBOL_BLUETOOTH, connected);
            }

        } else {
            // It's not a partial update, so simply draw the Bluetooth indicator
            drawIndicator(dc, mLeftX, SYMBOL_BLUETOOTH, connected);
        }

        mPhoneConnected = connected;
    }

    /**
     * Draws the given indicator glyph at the given coordinates. The color will depend on
     * whether the indicator is considered active or not.
     */
    function drawIndicator(dc, x, glyph, active) {
        if (active) {
            dc.setColor(gColorIndicatorActive, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(gColorIndicatorInactive, Graphics.COLOR_TRANSPARENT);
        }

        //dc.fillRectangle(x, mY, SYMBOL_SIZE, SYMBOL_SIZE);
        dc.drawText(
            x,
            mY,
            gSymbolsFont,
            glyph,
            Graphics.TEXT_JUSTIFY_LEFT
        );
    }

}