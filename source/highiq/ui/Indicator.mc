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

    // Whether the clip rect has already been initialized.
    private var mClipInitialized = false;
    // Size of the clip rect to quickly redraw the indicator during partial updates.
    private var mClipDimensions = null;
    
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
            
            // The clip is not initialized if the behavior actually supports partial
            // updates (only then is the clip necessary)
            mClipInitialized = !mBehavior.supportsPartialUpdate();
            
        } else {
            // No behavior; release resources
            mIconFont = null;
            mValueFont = null;
            mClipDimensions = null;
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
    
    private function initializeClip(dc) {
        if (mBehavior.supportsPartialUpdate()) {
            // Icon dimensions
            mClipDimensions = dc.getTextDimensions(
                mBehavior.getIconCharacter(),
                mIconFont);
        
            // Maximum text dimensions, if there is any text
            var longestValue = mBehavior.getLongestValue();
            if (longestValue != null) {
                var valueClipDimensions = dc.getTextDimensions(
                    mBehavior.getLongestValue(),
                    mValueFont);
                
                if (valueClipDimensions[0] > mClipDimensions[0]) {
                    mClipDimensions[0] = valueClipDimensions[0];
                }
                
                // This assumes that the value text will always be rendered
                // below the icon
                mClipDimensions[1] = mTopYValueOffset + valueClipDimensions[1];
            }
                
        } else {
            mClipDimensions = null;
        }
    }
    
    /**
     * Draws the indicator.
     */
    public function draw(dc) {
        if (mBehavior != null) {
            // Update clipping region, if necessary
            if (!mClipInitialized) {
                initializeClip(dc);
                mClipInitialized = true;
            }
        
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
        
        if (partial && mClipDimensions != null) {
        	var leftX = mCenterX - mClipDimensions[0] / 2;
            dc.setClip(
                leftX,
                mTopY,
                mClipDimensions[0],
                mClipDimensions[1]
            );
            
            // Be sure to erase the background to avoid text artifacts
            dc.setColor(mBehavior.getBackgroundColor(), Graphics.COLOR_TRANSPARENT);
            dc.fillRectangle(leftX, mTopY, mClipDimensions[0], mClipDimensions[1]);
        }
        
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
            if (value == null) {
                value = "-";
            }
            
            dc.setColor(mBehavior.getValueColor(), mBehavior.getBackgroundColor());
            dc.drawText(
                mCenterX,
                mTopY + mTopYValueOffset,
                mValueFont,
                value,
                Graphics.TEXT_JUSTIFY_CENTER
            );
        }
        
        if (partial && mClipDimensions != null) {
            dc.clearClip();
        }
    }

}