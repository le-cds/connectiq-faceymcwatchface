/* Defines property keys. */

const APPOINTMENT_UPDATE_INTERVAL = "AppointmentUpdateInterval";

///////////////////////////////////////////////////////////////////////////////////
// Indicators

const INDICATOR_COUNT = 6;

enum /* INDICATORS */ {
    INDICATOR_TOP_LEFT,
    INDICATOR_TOP_RIGHT,
    INDICATOR_CENTER,
    INDICATOR_BOTTOM_LEFT,
    INDICATOR_BOTTOM_CENTER,
    INDICATOR_BOTTOM_RIGHT
}

const INDICATOR_NAMES = [
    "IndicatorTopLeft",
    "IndicatorTopRight",
    "IndicatorCenter",
    "IndicatorBottomLeft",
    "IndicatorBottomCenter",
    "IndicatorBottomRight"
];

///////////////////////////////////////////////////////////////////////////////////
// Meters

const METER_COUNT = 2;

enum /* METERS */ {
    METER_LEFT,
    METER_RIGHT
}

const METER_NAMES = [
    "MeterLeft",
    "MeterRight"
];
