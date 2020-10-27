using Toybox.Application;
using Toybox.Graphics;
using Toybox.System;
using Toybox.WatchUi;

const MIN_WHOLE_SEGMENT_HEIGHT = 5;

enum /* GOAL_METER_STYLES */ {
    STYLE_ALL_SEGMENTS,
    STYLE_ALL_SEGMENTS_MERGED,
    STYLE_FILLED_SEGMENTS,
    STYLE_FILLED_SEGMENTS_MERGED
}

/**
 * Meter indicators display bars the set a current value against a possible maximum. What exactly
 * they show must be configured through a MeterBehavior object. 
 *
 * Buffered drawing behaviour:
 * - On initialisation: calculate clip width (non-trivial for arc shape); create buffers for empty
 *                      and filled segments.
 * - On setting current/max values: if max changes, re-calculate segment layout and set dirty buffer
 *                                  flag; if current changes, recalculate fill height.
 * - On draw: if buffers are dirty, redraw them and clear flag; clip appropriate portion of each
 *            buffer to screen. Each buffer contains all segments in appropriate colour, with
 *            separators. Maximum of 2 draws to screen on each draw() cycle.
 *
 * This code is based on code from the Crystal watch face, which can be found at:
 * https://github.com/warmsound/crystal-face
 */
class Meter extends WatchUi.Drawable {

    // MeterBehavior object that determines what this meter displays.
    private var mBehavior = null;

    // The side we're on (either :left or :right)
    private var mSide;
    // The display style
    private var mStyle;
    // The stroke width
    private var mStroke;
    // Clip width of meter
    private var mWidth;
    // Clip height of meter
    private var mHeight;
    // Current stroke width of separator bars
    private var mSeparator = 0;

    // Font used to draw the icon.
    private var mIconFont;
    // X coordinate of icon
    private var mIconX;
    // Y coordinate of icon.
    private var mIconY;

    // Array of segment heights, in pixels, excluding separators.
    private var mSegments;
    // Total height of filled segments, in pixels, including separators.
    private var mFillHeight;

    // Bitmap buffer containing all full segments
    (:buffered) private var mFilledBuffer;
    // Bitmap buffer containing all empty segments
    (:buffered) private var mEmptyBuffer;

    // Buffers need to be recreated on next draw() cycle.
    private var mBuffersNeedRecreate = true;
    // Buffers need to be redrawn on next draw() cycle.
    private var mBuffersNeedRedraw = true;

    // The current value to be displayed.
    private var mCurrentValue;
    // The current maximum value.
    private var mMaxValue;

    public function initialize(params) {
        Drawable.initialize(params);

        mSide = params[:side];
        mStyle = params[:style];
        mStroke = params[:stroke];
        mHeight = params[:height];
        
        // Only read separator width from layout if a multi-segment style is enabled (in
        // the original code, this is user-configurable and can change during runtime)
        if (mStyle == STYLE_ALL_SEGMENTS || mStyle == STYLE_FILLED_SEGMENTS) {
            mSeparator = params[:separator];
        }

        mIconX = params[:iconX];
        mIconY = params[:iconY];

        mWidth = getWidth();
    }

    private function getWidth() {
        var width;
        
        var halfScreenWidth;
        var innerRadius;

        if (System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_RECTANGLE) {
            width = mStroke;
        } else {
            halfScreenWidth = System.getDeviceSettings().screenWidth / 2;
            innerRadius = halfScreenWidth - mStroke; 
            width = halfScreenWidth - Math.sqrt(Math.pow(innerRadius, 2) - Math.pow(mHeight / 2, 2));
            
            // Round up to cover partial pixels.
            width = Math.ceil(width).toNumber();
        }

        return width;
    }
    
    public function setBehavior(behavior) {
        // Things will be properly reset upon the next draw cycle
        mBehavior = behavior;
        mBuffersNeedRecreate = true;
        
        if (mBehavior != null) {
            // There is a behavior; cache resources
            mIconFont = mBehavior.getIconFont();
        } else {
            // No behavior; release resources
            mIconFont = null;
        }
    }

    /**
     * Call to set the current and maximum values to be displayed.
     */
    private function setValues(current, max) {
        // If max value changes, recalculate and cache segment layout, and set mBuffersNeedRedraw flag.
        // Can't redraw buffers here, as we don't have reference to screen DC, in order to determine
        // its dimensions - do this later, in draw() (already in draw cycle, so no real benefit in
        // fetching screen width). Clear current value to force recalculation of fillHeight.
        if (max != mMaxValue) {
            mMaxValue = max;
            mCurrentValue = null;

            mSegments = getSegments();
            mBuffersNeedRedraw = true;
        }

        // If current value changes, recalculate fill height, ahead of draw().
        if (current != mCurrentValue) {
            mCurrentValue = current;
            mFillHeight = getFillHeight(mSegments);
        }
    }

    // Different draw algorithms have been tried:
    // 1. Draw each segment as a circle, clipped to a rectangle of the desired height, direct to screen DC.
    //    Intuitive, but expensive.
    // 2. Buffered drawing: a buffer each for filled and unfilled segments (full height). Each buffer drawn as a single circle
    //    (only the part that overlaps the buffer DC is visible). Segments created by drawing horizontal lines of background
    //    colour. Screen DC is drawn from combination of two buffers, clipped to the desired fill height.
    // 3. Unbuffered drawing: no buffer, and no clip support. Want common drawBuffer() function, so draw each segment as
    //    rectangle, then draw circular background colour mask between both meters. This requires an extra drawable in the layout,
    //    expensive, so only use this strategy for unbuffered drawing. For buffered, the mask can be drawn into each buffer.
    public function draw(dc) {
        // Don't bother if there's no behavior set yet
        if (mBehavior == null) {
            return;
        }
        
        // Update our values, which may cause us to redraw buffers
        mBehavior.update();
        setValues(mBehavior.getCurrValue(), mBehavior.getMaxValue());
        
        // Determine coordinates
        var left = (mSide == :left) ? 0 : (dc.getWidth() - mWidth);
        var top = (dc.getHeight() - mHeight) / 2;

        // Force unbuffered drawing on fr735xt (CIQ 2.x) to reduce memory usage.
        // Now changed to use buffered drawing only on round watches.
        if ((Graphics has :BufferedBitmap) && (Graphics.Dc has :setClip)
            && (System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_ROUND)) {

            drawBuffered(dc, left, top);
        
        } else {
            // Filled segments: 0 --> fill height.
            drawSegments(dc, left, top, mBehavior.getActiveMeterColor(), mSegments, 0, mFillHeight);

            // Unfilled segments, if necessary: fill height --> height.
            if (mStyle == STYLE_ALL_SEGMENTS || mStyle == STYLE_ALL_SEGMENTS_MERGED) {
                drawSegments(dc, left, top, mBehavior.getInactiveMeterColor(), mSegments, mFillHeight, mHeight);
            }
        }

        // Draw the icon
        dc.setColor(mBehavior.getIconColor(), mBehavior.getBackgroundColor());
        dc.drawText(
            mIconX,
            mIconY,
            mIconFont,
            mBehavior.getIconCharacter(),
            Graphics.TEXT_JUSTIFY_LEFT
        );
    }

    /**
     * Redraw buffers if dirty, then draw from buffer to screen: from filled buffer up to fill height, then from
     * empty buffer for remaining height.
     */
    (:buffered)
    private function drawBuffered(dc, left, top) {
        var emptyBufferDc;
        var filledBufferDc;

        var clipBottom;
        var clipTop;
        var clipHeight;

        var halfScreenDcWidth = (dc.getWidth() / 2);
        var x;
        var radius;

        // Recreate buffers only if this is the very first draw(), or if optimised colour palette has changed e.g. theme colour
        // change.
        if (mBuffersNeedRecreate) {
            mEmptyBuffer = createSegmentBuffer(mBehavior.getInactiveMeterColor());
            mFilledBuffer = createSegmentBuffer(mBehavior.getActiveMeterColor());
            mBuffersNeedRecreate = false;
            // Ensure newly-created buffers are drawn next.
            mBuffersNeedRedraw = true;
        }

        // Redraw buffers only if maximum value changes.
        if (mBuffersNeedRedraw) {

            // Clear both buffers with background colour.
            emptyBufferDc = mEmptyBuffer.getDc();
            emptyBufferDc.setColor(Graphics.COLOR_TRANSPARENT, mBehavior.getBackgroundColor());
            emptyBufferDc.clear();

            filledBufferDc = mFilledBuffer.getDc();
            filledBufferDc.setColor(Graphics.COLOR_TRANSPARENT, mBehavior.getBackgroundColor());
            filledBufferDc.clear();

            // Draw full fill height for each buffer.
            drawSegments(emptyBufferDc, 0, 0, mBehavior.getInactiveMeterColor(), mSegments, 0, mHeight);
            // #62 Could avoid drawing filled segments buffer if style is not ALL_SEGMENTS or ALL_SEGMENTS_MERGED.
            drawSegments(filledBufferDc, 0, 0, mBehavior.getActiveMeterColor(), mSegments, 0, mHeight);

            // For arc meters, draw circular mask for each buffer.
            if (System.getDeviceSettings().screenShape != System.SCREEN_SHAPE_RECTANGLE) {
                // Beyond right edge of bufferDc : Beyond left edge of bufferDc.
                x = (mSide == :left) ? halfScreenDcWidth : (mWidth - halfScreenDcWidth - 1);
                radius = halfScreenDcWidth - mStroke;

                emptyBufferDc.setColor(mBehavior.getBackgroundColor(), Graphics.COLOR_TRANSPARENT);
                emptyBufferDc.fillCircle(x, (mHeight / 2), radius);

                filledBufferDc.setColor(mBehavior.getBackgroundColor(), Graphics.COLOR_TRANSPARENT);
                filledBufferDc.fillCircle(x, (mHeight / 2), radius);
            }

            mBuffersNeedRedraw = false;
        }

        // Draw filled segments.
        clipBottom = dc.getHeight() - top;
        clipTop = clipBottom - mFillHeight;
        clipHeight = clipBottom - clipTop;

        if (clipHeight > 0) {
            dc.setClip(left, clipTop, mWidth, clipHeight);
            dc.drawBitmap(left, top, mFilledBuffer);
        }

        // Draw unfilled segments.
        // #62 ALL_SEGMENTS or ALL_SEGMENTS_MERGED.
        if (mStyle == STYLE_ALL_SEGMENTS || mStyle == STYLE_ALL_SEGMENTS_MERGED) {
            clipBottom = clipTop;
            clipTop = top;
            clipHeight = clipBottom - clipTop;

            if (clipHeight > 0) {
                dc.setClip(left, clipTop, mWidth, clipHeight);
                dc.drawBitmap(left, top, mEmptyBuffer);
            }
        }

        dc.clearClip();
    }

    /**
     * Use restricted palette, to conserve memory (four buffers per watchface).
     */
    (:buffered)
    private function createSegmentBuffer(fillColour) {
        return new Graphics.BufferedBitmap({
            :width => mWidth,
            :height => mHeight,

            // First palette colour appears to determine initial colour of buffer.
            :palette => [mBehavior.getBackgroundColor(), fillColour]
        });
    }

    // dc can be screen or buffer DC, depending on drawing mode.
    // x and y are co-ordinates of top-left corner of meter.
    // start/endFillHeight are pixel fill heights including separators, starting from zero at bottom.
    private function drawSegments(dc, x, y, fillColour, segments, startFillHeight, endFillHeight) {
        var segmentStart = 0;
        var segmentEnd;

        var fillStart;
        var fillEnd;
        var fillHeight;

        y += mHeight; // Start from bottom.

        dc.setColor(fillColour, Graphics.COLOR_TRANSPARENT /* Graphics.COLOR_RED */);

        // Draw rectangles, separator-width apart vertically, starting from bottom.
        for (var i = 0; i < segments.size(); ++i) {         
            segmentEnd = segmentStart + segments[i];

            // Full segment is filled.
            if ((segmentStart >= startFillHeight) && (segmentEnd <= endFillHeight)) {
                fillStart = segmentStart;
                fillEnd = segmentEnd;

            // Bottom of this segment is filled.
            } else if (segmentStart >= startFillHeight) {
                fillStart = segmentStart;
                fillEnd = endFillHeight;

            // Top of this segment is filled.
            } else if (segmentEnd <= endFillHeight) {
                fillStart = startFillHeight;
                fillEnd = segmentEnd;
            
            // Segment is not filled.
            } else {
                fillStart = 0;
                fillEnd = 0;
            }

            fillHeight = fillEnd - fillStart;
            if (fillHeight) {
                dc.fillRectangle(x, y - fillStart - fillHeight, mWidth, fillHeight);
            }

            segmentStart = segmentEnd + mSeparator;
        }
    }

    // Return array of segment heights.
    // Last segment may be partial segment; if so, ensure its height is at least 1 pixel.
    // Segment heights rounded to nearest pixel, so neighbouring whole segments may differ in height by a pixel.
    private function getSegments() {
        // Value each whole segment represents.
        var segmentScale = getSegmentScale();

        // Including any partial. Force floating-point division.
        var numSegments = mMaxValue * 1.0 / segmentScale;
        var numSeparators = Math.ceil(numSegments) - 1;

        // Subtract total separator height from full height.
        var totalSegmentHeight = mHeight - (numSeparators * mSeparator);
        // Force floating-point division.
        var segmentHeight = totalSegmentHeight * 1.0 / numSegments;

        var segments = new [Math.ceil(numSegments)];
        var start, end, height;

        for (var i = 0; i < segments.size(); ++i) {
            start = Math.round(i * segmentHeight);
            end = Math.round((i + 1) * segmentHeight);

            // Last segment is partial.
            if (end > totalSegmentHeight) {
                end = totalSegmentHeight;
            }

            height = end - start;

            segments[i] = height.toNumber();
        }

        return segments;
    }

    private function getFillHeight(segments) {
        var fillHeight;

        var i;

        var totalSegmentHeight = 0;
        for (i = 0; i < segments.size(); ++i) {
            totalSegmentHeight += segments[i];
        }

        // Excluding separators.
        var remainingFillHeight = Math.floor((mCurrentValue * 1.0 / mMaxValue) * totalSegmentHeight).toNumber();
        fillHeight = remainingFillHeight;

        for (i = 0; i < segments.size(); ++i) {
            remainingFillHeight -= segments[i];
            if (remainingFillHeight > 0) {
                // Fill extends beyond end of this segment, so add separator height.
                fillHeight += mSeparator;
            } else {
                // Fill does not extend beyond end of this segment, because this segment is not full.
                break;
            }
        }

        return fillHeight;
    }

    // Determine what value each whole segment represents.
    // Try each scale in SEGMENT_SCALES array, until MIN_SEGMENT_HEIGHT is breached.
    private function getSegmentScale() {
        var segmentScale;

        var tryScaleIndex = 0;
        var segmentHeight;
        var numSegments;
        var numSeparators;
        var totalSegmentHeight;

        var SEGMENT_SCALES = [1, 10, 100, 1000, 10000];

        do {
            segmentScale = SEGMENT_SCALES[tryScaleIndex];

            numSegments = mMaxValue * 1.0 / segmentScale;
            numSeparators = Math.ceil(numSegments);
            totalSegmentHeight = mHeight - (numSeparators * mSeparator);
            segmentHeight = Math.floor(totalSegmentHeight / numSegments);

            tryScaleIndex++;    
        } while (segmentHeight <= 5);

        return segmentScale;
    }
}