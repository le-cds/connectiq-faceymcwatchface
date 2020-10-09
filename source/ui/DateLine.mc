using Toybox.Time.Gregorian;
using Toybox.WatchUi;

/**
 * Displays the date line, centered at the y coordinate supplied through the layout.
 *
 * This code is based on code from the Crystal watch face, which can be found at:
 * https://github.com/warmsound/crystal-face
 *
 * Parameters:
 *   y   The y coordinate at which to draw the date.
 */
class DateLine extends WatchUi.Drawable {

    // The Y coordinate to draw the date at
    private var mY;

    // The current day.
    private var mDay = 0;
    // The month last time we checked it (we only update when it changes)
    private var mMonth;
    // The day's string representation, ready to be displayed
    private var mDayOfWeekString;
    // The month's string representation, ready to be displayed
    private var mMonthString;

    /**
     * Initialize the whole thing.
     */
    function initialize(params) {
        Drawable.initialize(params);

        // Initialize from parameters
        mY = params[:y];
    }

    /**
     * Updates the date. If it has changed, draws the date onto the device context.
     */
    function draw(dc) {
        // Supply DOW/month strings ourselves, rather than relying on Time.FORMAT_MEDIUM,
        //  as latter is inconsistent e.g. returns "Thurs" instead of "Thu". Load strings
        // just-in-time, to save memory. They rarely change, so worthwhile trade-off.
        var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);

        // Update the current day, if it has changed
        var day = now.day.format("%d");
        if (mDay != day) {
            mDay = day;

            // Update the day-of-week string (this always changes when the day changes
            // [citation needed])
            var resourceArray = [
                Rez.Strings.Sun,
                Rez.Strings.Mon,
                Rez.Strings.Tue,
                Rez.Strings.Wed,
                Rez.Strings.Thu,
                Rez.Strings.Fri,
                Rez.Strings.Sat
            ];
            mDayOfWeekString = WatchUi.loadResource(resourceArray[now.day_of_week - 1]);

            // Check if we need to update the month's string
            var month = now.month;
            if (month != mMonth) {
                mMonth = month;

                resourceArray = [
                    Rez.Strings.Jan,
                    Rez.Strings.Feb,
                    Rez.Strings.Mar,
                    Rez.Strings.Apr,
                    Rez.Strings.May,
                    Rez.Strings.Jun,
                    Rez.Strings.Jul,
                    Rez.Strings.Aug,
                    Rez.Strings.Sep,
                    Rez.Strings.Oct,
                    Rez.Strings.Nov,
                    Rez.Strings.Dec
                ];
                mMonthString = WatchUi.loadResource(resourceArray[mMonth - 1]);
            }

            drawTheDate(dc);
        }
    }

    /**
     * Actually draws the date. This assumes that mDay, mDayOfWeekString, and
     * mMonthString are up to date.
     */
    function drawTheDate(dc) {
        // Cobble together the date string
        var dateString = Lang.format(
            "$1$, $2$ $3$",
            [mDayOfWeekString, mMonthString, mDay]);

        // Compute the x coordinate such that the string ends up being centered
        var length = dc.getTextWidthInPixels(dateString, gDateFont);
        var x = (dc.getWidth() - length) / 2;

        // Draw the actual text
        dc.setColor(gColorDate, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x,
            mY,
            gDateFont,
            dateString,
            Graphics.TEXT_JUSTIFY_LEFT
        );
    }

}