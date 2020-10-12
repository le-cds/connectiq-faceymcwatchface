/**
 * An indicator which draws an icon as well as a line of text. A ValueIndicator needs
 * a ValueBehavior object to tell it how and what to draw.
 */
class ValueIndicator extends IconIndicator {

    ///////////////////////////////////////////////////////////////////////////////////
    // Layout Parameters
    
    // Offset from the top y position to the value's top border.
    private var mTopYValueOffset;
    
    ///////////////////////////////////////////////////////////////////////////////////
    // State
    
    // Cached value font.
    protected var mValueFont;
    
    ///////////////////////////////////////////////////////////////////////////////////
    // Behavior
    
    /**
     * Sets the gehavior that will define what this indicator does.
     */
    public function setBehavior(behavior) {
        IconIndicator.setBehavior(behavior);
        
        if (mBehavior != null) {
            // There is a behavior; cache resources
            mValueFont = mBehavior.getValueFont();
        } else {
            // No behavior; release resources
            mValueFont = null;
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////////
    // Drawing

    public function initialize(params) {
        IconIndicator.initialize(params);
        
        mTopYValueOffset = params[:topYValueOffset];
    }
    
    protected function doDraw(dc, partial) {
        // Draw the icon first
        IconIndicator.doDraw(dc, partial);
        
        // Draw the value
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