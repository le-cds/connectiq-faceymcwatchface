using Toybox.Application.Properties;
using Toybox.System;
using Toybox.Time;
using Toybox.WatchUi;

/**
 * Displays an indicator for the next calendar appointment.
 */
class CalendarIndicator extends WatchUi.Drawable {

    // The assumed width / height of each symbol
    private const SYMBOL_SIZE = 16;
    // Half of SYMBOL_SIZE.
    private const HALF_SYMBOL_SIZE = SYMBOL_SIZE / 2;

    // The characters used for the different symbols
    private const SYMBOL_CALENDAR = "G";

    // Whether we actually display anything or not
    private var mActive;

    // Y coordinate of the symbols.
    private var mY;
    // Y coordinate of the text.
    private var mTextY;
    // X coordinate of the indicator's center.
    private var mMidX;

    /**
     * Initialize the whole thing.
     */
    function initialize(params) {
        Drawable.initialize(params);

        // Initialize from parameters
        mY = params[:y];
        mTextY = mY + SYMBOL_SIZE;

        mMidX = System.getDeviceSettings().screenWidth / 2;

        // Load application settings
        onSettingsChanged();
    }

    /**
     * Re-reads the settings to check whether we actually need to display anything.
     */
    function onSettingsChanged() {
        mActive = Properties.getValue(ACTIVATE_APPOINTMENTS);
    }

    /**
     * Updates the date. If it has changed, draws the date onto the device context.
     */
    function draw(dc) {
        // If we're not actually active, draw nothing
        if (!mActive) {
            return;
        }

        var nextAppointment = getNextAppointment();

        if (nextAppointment == null) {
            drawIndicator(
                dc,
                mMidX,
                SYMBOL_CALENDAR,
                "",
                false);
        } else {
            var info = displayableMoment(nextAppointment);
            var appointmentText = Lang.format(
                "$1$:$2$$3$",
                [
                    info[:hour],
                    info[:minute],
                    info[:ampm]
                ]);

            drawIndicator(
                dc,
                mMidX,
                SYMBOL_CALENDAR,
                appointmentText,
                true);
        }
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