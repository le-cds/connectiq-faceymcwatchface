using Toybox.System;
using Toybox.WatchUi;

/**
 * Indicator which draws an icon and, optionally, a text. Needs an IndicatorBehavior
 * object to tell it how and what to draw.
 */
class Indicator extends WatchUi.Drawable {

    ///////////////////////////////////////////////////////////////////////////////////
    // Layout Parameters

    // X coordinate of this indicator's center.
    private var mCenterX;
    // Y coordinate of this incidcator's top border.
    private var mTopY;
    // Offset from the top y position to the value's top border.
    private var mTopYValueOffset;
    
    ///////////////////////////////////////////////////////////////////////////////////
    // State
    
    // The actual definition of how the indicator behaves.
    protected var mBehavior;
    // Size of the icon displayed. E.g., 16 for a 16x16 icon.
    protected var mIconSize;
    // Cached icon font.
    protected var mIconFont;
    // Cached value font.
    protected var mValueFont;
    
    ///////////////////////////////////////////////////////////////////////////////////
    // Behavior
    
    /**
     * Sets the gehavior that will define what this indicator does.
     */
    public function setBehavior(behavior) {
        mBehavior = behavior;
        
        if (mBehavior != null) {
            // There is a behavior; cache resources
            mIconSize = mBehavior.getIconSize();
            mIconFont = mBehavior.getIconFont();
            mValueFont = mBehavior.getValueFont();
        } else {
            // No behavior; release resources
            mIconFont = null;
            mValueFont = null;
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
        mTopYValueOffset = params[:topYValueOffset];
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
            && mBehavior.wantsPartialUpdate()) {
            
            doDraw(dc, true);
        }
    }
    
    /**
     * Implements the actual drawing.
     */
    protected function doDraw(dc, partial) {
        mBehavior.update();
        
        // Draw the icon
        dc.setColor(mBehavior.getIconColor(), mBehavior.getBackgroundColor());
        dc.drawText(
            mCenterX,
            mTopY,
            mIconFont,
            mBehavior.getIconCharacter(),
            Graphics.TEXT_JUSTIFY_CENTER);
        
        // Draw the value, if we're configured to do so and if there is any
        if (mTopYValueOffset != null) {
            var value = mBehavior.getValue();
            if (value != null) {
                dc.setColor(mBehavior.getValueColor(), mBehavior.getBackgroundColor());
                dc.drawText(
                    mCenterX,
                    mTopY + mTopYValueOffset,
                    mValueFont,
                    mBehavior.getValue(),
                    Graphics.TEXT_JUSTIFY_CENTER
                );
            }
        }
    }

}