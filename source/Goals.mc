using Toybox.ActivityMonitor;

/* Contains code to access the different types of goals.
 *
 * This code is based on code from the Crystal watch face, which can be found at:
 * https://github.com/warmsound/crystal-face
 */


enum /* GOAL_TYPES */ {
    GOAL_TYPE_BATTERY = -1,
    GOAL_TYPE_STEPS = 0,
    GOAL_TYPE_FLOORS_CLIMBED
}


// Return a dictionary that contains the :current and :max value of the given goal
// type.
function getValuesForGoalType(type) {
    var values = {
        :current => 0,
        :max => 1
    };

    var info = ActivityMonitor.getInfo();

    switch (type) {
        case GOAL_TYPE_STEPS:
            values[:current] = info.steps;
            values[:max] = info.stepGoal;
            break;

        case GOAL_TYPE_FLOORS_CLIMBED:
            if (info has :floorsClimbed) {
                values[:current] = info.floorsClimbed;
                values[:max] = info.floorsClimbedGoal;
            } else {
                values[:isValid] = false;
            }

            break;

        case GOAL_TYPE_BATTERY:
            values[:current] = Math.floor(System.getSystemStats().battery);
            values[:max] = 100;
            break;
    }

    // #16: If user has set goal to zero, or negative (in simulator), show as invalid. Set max to 1
    // to avoid divide-by-zero crash in GoalMeter.getSegmentScale().
    if (values[:max] < 1) {
        values[:max] = 1;
    }

    return values;
}
