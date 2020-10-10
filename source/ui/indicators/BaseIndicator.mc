using Toybox.System;
using Toybox.WatchUi;

/**
 * Subclasses should implement:
 * - isIndicating()
 * 
 * Subclasses can implement:
 * - supportsPartialUpdate()
 * - needsUpdate()
 * - initialize(params) -> must call superclass implementation
 */
class BaseIndicator extends WatchUi.Drawable {

    ///////////////////////////////////////////////////////////////////////////////////
    // Layout Parameters

    // X coordinate of this indicator's center.
    private var mCenterX;
    // Y coordinate of this incidcator's top border.
    private var mTopY;
    
    ///////////////////////////////////////////////////////////////////////////////////
    // Subclass Settings
    
    // Size of the icon (e.g., 16 for a 16x16 icon).
    protected var mIconSize = 1;
    
    ///////////////////////////////////////////////////////////////////////////////////
    // Drawable
    
    /**
     * Initializes this thing. Subclasses may override this for additional initialization,
     * but must call this superclass implementation.
     */
    public function initialize(params) {
        Drawable.initialize(params);
        
        mCenterX = params[:centerX];
        mTopY = params[:topY];
    }
    
    /**
     * Draws the indicator.
     */
    public function draw(dc) {
        drawIcon(dc, false);
    }
    
    /**
     * Partially draws the indicator, if supported and necessary.
     */
    public function partialDraw(dc) {
        if (supportsPartialUpdate() && needsUpdate()) {
            drawIcon(dc, true);
        }
    }
    
    /**
     * Implements the actual drawing.
     */
    private function drawIcon(dc, partial) {
        // If this is a partial update, we need to manually clear our little area
        // of the screen
        if (partial) {
            dc.setClip(
                mCenterX - mIconSize / 2,
                mTopY,
                mIconSize,
                mIconSize);
            dc.setColor(Graphics.COLOR_TRANSPARENT, gColorBackground);
            dc.clear();
        }
        
        // Draw the icon
        if (isIndicating()) {
            dc.setColor(gColorIndicatorActive, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(gColorIndicatorInactive, Graphics.COLOR_TRANSPARENT);
        }
        
        dc.drawText(
            mCenterX,
            mTopY,
            gSymbolsFont,
            getIconCharacter(),
            Graphics.TEXT_JUSTIFY_CENTER);
    }
    
    ///////////////////////////////////////////////////////////////////////////////////
    // Subclass Behavior
    
    /**
     * Returns whether or not this indicator updates during partial updates. By default,
     * this is not the case, which will cause the indicator to update only once per
     * minute or when the watchface is completely redrawn anyway. Override and return
     * true only if the indicator displays information that should be updated more often
     * than that.
     */
    public function supportsPartialUpdate() {
        return false;
    }
    
    /**
     * If the indicator supports partial updates, this function is used to check whether
     * an update is actually required. This is ignored during regular updates.
     */
    protected function needsUpdate() {
        return true;
    }
    
    /**
     * Returns whether or not the indicator should light up. This function should be
     * implemented by subclasses.
     */
    protected function isIndicating() {
        return false;
    }
    
    /**
     * Returns the current icon character. This may change depending on the indicator's
     * state.
     */
    protected function getIconCharacter() {
        return ' ';
    }

}