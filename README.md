# Facey McWatchface

A watchface for Garmin smartwatches with a focus on communication. Looks something like this:

![Watchface design](promo/diagram.png)


## Main Feature: Time of Upcoming Appointment

The watchface is able to show the time of the upcoming appointment. Only appointments in the upcoming 24 hours (minus 5 minutes) are displayed. The whole thing only works if a companion app, [Calendar IQ Connector](https://github.com/le-cds/android-calendariq), is installed on an Android mobile the watch is connected to. That app will send information on upcoming appointments to the watch in regular intervals.

## Features Everyone Else Has as Well

There are…

* …two indicators at the top that show symbols, but no text.
* …four indicators at the bottom that show symbols _and_ text, because that is how they roll.
* …two range meters at the left and the right.

All of them can be freely configured to show stuff.

### Indicators

* Active alarms
* Time of upcoming appointment
* Battery charge
* Bluetooth state
* Do Not Disturb state
* Heart rate
* Unread notifications

### Range Meters

* Batty charge
* Floors
* Steps

## Supported Smartwatches

### Tested

I have either used the watchface myself on the following devices (successfully, I might add), or know of people who have:

* vívoactive® 3 (all variations)

### Untested

The following devices _should_ work:

* Approach® S62
* D2™ Charlie, Delta (all variations)
* Darth Vader™
* Descent™ Mk1
* fēnix® 5 (Plus, S Plus, X, X Plus)
* fēnix® 6 (Solar, Dual Power, Pro, Sapphire, Pro Solar, Pro Dual Power, S, S Solar, S Dual Power, S Pro, S Spphire, S Pro Slar, S Pro Dual Power)
* First Avenger
* Forerunner® 245 (Music), 645 (Music), 745, 935, 945
* MARQ™ Adventurer, Athlete, Aviator, Captain (American Magic Edition), Commander, Driver, Expedition, Golfer
* quatix® 5 and 6
* tactix® Charlie
* vívoactive® 4

## For Developers

Here’s two notes for my fellow developers:

* There might be a few interesting bits of code hidden inside this code base. Look at [the `highiq` folder](https://github.com/le-cds/connectiq-faceymcwatchface/tree/master/source/highiq) for inspiration! Should you use some of the code in there, please drop me a line – it’s always nice to know if code’s been helpful to others!
* If you’re interested in contributing, head over to the contributions documentation file for details. Nothing surprising in there, though, so you might as well skip it and start coding right away…

## Attributions

This project stands on the shoulders of the following people:

- The [Crystal](https://apps.garmin.com/en-GB/apps/9fd04d09-8c80-4c81-9257-17cfa0f0081b) watchface ([GitHub repository](https://github.com/warmsound/crystal-face)).
- [Activity](https://thenounproject.com/term/activity/1955073/) icon by shashank singh from the Noun Project
- [Arrow](https://thenounproject.com/term/arrow/3257700/) icon by agus raharjo from the Noun Project
- [Steps](https://thenounproject.com/term/steps/87667/) icon by Eugen Belyakoff from the Noun Project
