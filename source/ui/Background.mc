using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;
using FaceyMcWatchface.UiResources as UiRes;

/**
 * Clears the whole screen and draws the background in the configured
 * colour.
 */
class Background extends WatchUi.Drawable {

    function initialize() {
        var dictionary = {
            :identifier => "Background"
        };

        Drawable.initialize(dictionary);
    }

    function draw(dc) {
        // Set the background color then call to clear the screen
        dc.setColor(Graphics.COLOR_TRANSPARENT, UiRes.gColorBackground);
        dc.clear();
    }

}
