using Toybox.Application;
using Toybox.Graphics;
using Toybox.System;
using Toybox.WatchUi;

const MIN_WHOLE_SEGMENT_HEIGHT = 5;

enum /* GOAL_METER_STYLES */ {
    STYLE_MULTI_SEGMENTS,
    STYLE_SINGLE_SEGMENT
}

/**
 * Goal meters display the progress towards a goal. This version has been stripped of a lot of
 * functionality and adaptibility as compared to the original since it's geared towards the
 * Vivoactive 3.
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
class GoalMeter extends WatchUi.Drawable {

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
    private var mSeparator;
    // Stroke width of separator bars specified in layout
    private var mLayoutSeparator;

    // The symbol character
    private var mSymbol;
    // X coordinate of symbol
    private var mSymbolX;
    // Y coordinate of symbol.
    private var mSymbolY;

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

    function initialize(params) {
        Drawable.initialize(params);

        mSide = params[:side];
        mStyle = params[:style];
        mStroke = params[:stroke];
        mHeight = params[:height];
        mLayoutSeparator = params[:separator];

        mSymbolX = params[:symbolX];
        mSymbolY = params[:symbolY];

        // Read meter style setting to determine current separator width.
        onSettingsChanged();

        mWidth = getWidth();
    }

    function getWidth() {
        var halfScreenWidth = System.getDeviceSettings().screenWidth / 2;
        var innerRadius = halfScreenWidth - mStroke;

        var width = halfScreenWidth - Math.sqrt(Math.pow(innerRadius, 2) - Math.pow(mHeight / 2, 2));

        // Round up to cover partial pixels.
        return Math.ceil(width).toNumber();
    }

    /**
     * Call to set the current and maximum values to be displayed.
     */
    function setValues(symbol, current, max) {
        mSymbol = symbol;

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

    function onSettingsChanged() {
        mBuffersNeedRecreate = true;

        // #18 Only read separator width from layout if multi segment style is selected.
        if (mStyle == STYLE_MULTI_SEGMENTS) {
            // Force recalculation of mSegments in setValues() if mSeparator is about to change.
            if (mSeparator != mLayoutSeparator) {
                mMaxValue = null;
            }

            mSeparator = mLayoutSeparator;

        } else {
            // Force recalculation of mSegments in setValues() if mSeparator is about to change.
            if (mSeparator != 0) {
                mMaxValue = null;
            }

            mSeparator = 0;
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
    function draw(dc) {
        // Determine coordinates
        var left;
        if (mSide == :left) {
            left = 0;
        } else {
            left = dc.getWidth() - mWidth;
        }

        var top = (dc.getHeight() - mHeight) / 2;

        drawBuffered(dc, left, top);

        // Draw the symbol
        if (mCurrentValue >= mMaxValue) {
            dc.setColor(gColorMeterReached, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(gColorMeterNotReached, Graphics.COLOR_TRANSPARENT);
        }
        dc.drawText(
            mSymbolX,
            mSymbolY,
            gSymbolsFont,
            mSymbol,
            Graphics.TEXT_JUSTIFY_LEFT
        );
    }

    /**
     * Redraw buffers if dirty, then draw from buffer to screen: from filled buffer up to fill height, then from
     * empty buffer for remaining height.
     */
    (:buffered)
    function drawBuffered(dc, left, top) {
        var emptyBufferDc;
        var filledBufferDc;

        var clipBottom;
        var clipTop;
        var clipHeight;

        var halfScreenDcWidth = (dc.getWidth() / 2);
        var x;
        var radius;

        // Recreate buffers only if necessary
        if (mBuffersNeedRecreate) {
            mEmptyBuffer = createSegmentBuffer(gColorMeterBackground);
            mFilledBuffer = createSegmentBuffer(gColorHighlights);
            mBuffersNeedRecreate = false;


            // Ensure newly-created buffers are drawn next.
            mBuffersNeedRedraw = true;
        }

        // Redraw buffers only if maximum value changes.
        if (mBuffersNeedRedraw) {
            // Clear both buffers with background colour.
            emptyBufferDc = mEmptyBuffer.getDc();
            emptyBufferDc.setColor(Graphics.COLOR_TRANSPARENT, gColorBackground);
            emptyBufferDc.clear();

            filledBufferDc = mFilledBuffer.getDc();
            filledBufferDc.setColor(Graphics.COLOR_TRANSPARENT, gColorBackground);
            filledBufferDc.clear();

            // Draw full fill height for each buffer.
            drawSegments(emptyBufferDc, 0, 0, gColorMeterBackground, mSegments, 0, mHeight);
            drawSegments(filledBufferDc, 0, 0, gColorHighlights, mSegments, 0, mHeight);

            // Draw circular mask for each buffer.
            if (mSide == :left) {
                // Beyond right edge of bufferDc.
                x = halfScreenDcWidth;
            } else {
                // Beyond left edge of bufferDc.
                x = mWidth - halfScreenDcWidth - 1;
            }
            radius = halfScreenDcWidth - mStroke;

            emptyBufferDc.setColor(gColorBackground, Graphics.COLOR_TRANSPARENT);
            emptyBufferDc.fillCircle(x, (mHeight / 2), radius);

            filledBufferDc.setColor(gColorBackground, Graphics.COLOR_TRANSPARENT);
            filledBufferDc.fillCircle(x, (mHeight / 2), radius);

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
        clipBottom = clipTop;
        clipTop = top;
        clipHeight = clipBottom - clipTop;

        if (clipHeight > 0) {
            dc.setClip(left, clipTop, mWidth, clipHeight);
            dc.drawBitmap(left, top, mEmptyBuffer);
        }

        dc.clearClip();
    }

    /**
     * Use restricted palette, to conserve memory (four buffers per watchface).
     */
    (:buffered)
    function createSegmentBuffer(fillColour) {
        return new Graphics.BufferedBitmap({
            :width => mWidth,
            :height => mHeight,

            // First palette colour appears to determine initial colour of buffer.
            :palette => [gColorBackground, fillColour]
        });
    }

    // dc can be screen or buffer DC, depending on drawing mode.
    // x and y are co-ordinates of top-left corner of meter.
    // start/endFillHeight are pixel fill heights including separators, starting from zero at bottom.
    function drawSegments(dc, x, y, fillColour, segments, startFillHeight, endFillHeight) {
        var segmentStart = 0;
        var segmentEnd;

        var fillStart;
        var fillEnd;
        var fillHeight;

        y += mHeight; // Start from bottom.

        dc.setColor(fillColour, Graphics.COLOR_TRANSPARENT);

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
    function getSegments() {
        // Value each whole segment represents.
        var segmentScale = getSegmentScale();

        // Including any partial. Force floating-point division.
        var numSegments = mMaxValue * 1.0 / segmentScale;
        var numSeparators = Math.ceil(numSegments) - 1;

        // Subtract total separator height from full height.
        var totalSegmentHeight = mHeight - (numSeparators * mSeparator);
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

    function getFillHeight(segments) {
        var fillHeight;

        var i;

        var totalSegmentHeight = 0;
        for (i = 0; i < segments.size(); ++i) {
            totalSegmentHeight += segments[i];
        }

        var remainingFillHeight = Math.floor((mCurrentValue * 1.0 / mMaxValue) * totalSegmentHeight).toNumber(); // Excluding separators.
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
    function getSegmentScale() {
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
        } while (segmentHeight <= MIN_WHOLE_SEGMENT_HEIGHT);

        return segmentScale;
    }
}