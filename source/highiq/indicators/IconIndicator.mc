using Toybox.System;
using Toybox.WatchUi;

/**
 * Indicator which draws an icon. An IconIndicator needs an IconBehavior object to tell
 * it how and what to draw.
 */
class IconIndicator extends WatchUi.Drawable {

    ///////////////////////////////////////////////////////////////////////////////////
    // Layout Parameters

    // X coordinate of this indicator's center.
    protected var mCenterX;
    // Y coordinate of this incidcator's top border.
    protected var mTopY;
    
    ///////////////////////////////////////////////////////////////////////////////////
    // State
    
    // The actual definition of how the indicator behaves.
    protected var mBehavior;
    // Cached icon font.
    protected var mIconFont;
    // Size of the icon displayed. E.g., 16 for a 16x16 icon.
    protected var mIconSize;
    
    ///////////////////////////////////////////////////////////////////////////////////
    // Behavior
    
    /**
     * Sets the gehavior that will define what this indicator does.
     */
    public function setBehavior(behavior) {
        mBehavior = behavior;
        
        if (mBehavior != null) {
            // There is a behavior; cache resources
            mIconFont = mBehavior.getIconFont();
            mIconSize = mBehavior.getIconSize();
        } else {
            // No behavior; release resources
            mIconFont = null;
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////////
    // Drawing
    
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
        if (mBehavior != null) {
            doDraw(dc, false);
        }
    }
    
    /**
     * Partially draws the indicator, if supported and necessary.
     */
    public function partialDraw(dc) {
        if (mBehavior != null
            && mBehavior.supportsPartialUpdate()
            && mBehavior.needsUpdate()) {
            
            doDraw(dc, true);
        }
    }
    
    /**
     * Implements the actual drawing.
     */
    protected function doDraw(dc, partial) {
        mBehavior.update();
    
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
        dc.setColor(mBehavior.getIconColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            mCenterX,
            mTopY,
            mIconFont,
            mBehavior.getIconCharacter(),
            Graphics.TEXT_JUSTIFY_CENTER);
    }

}