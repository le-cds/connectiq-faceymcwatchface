# Facey McWatchface Cook Book

Facey McWatchface has become surprisingly complex. This cook book provides a few recipes for common tasks.

## Adding a Indicator / Meter Behaviour

Adding behaviours is rather annoying since it touches upon a lot of pieces of code. The project might better off generating most of that code from some sort of description, but then again there are only so many behaviours that will be added and it would make the development process more complex, so…

Anyway, this is what one has to do to add a new behavior.

1. Find and add an appropriate icon to `resources/fonts/symbols_font.afdesign`.
2. Export the new icon as part of the font and edit `symbols_font.fnt`.
3. Export the new icon as a 32x32 pixel icon in `resources/drawables` and register it in `drawables.xml`. Note that the ID is important and will be used throughout other files as well.
4. Using the same ID, add a displayable string for the behaviour in `resources/strings/strings.xml`.
5. Add it as a possible indicator or meter setting value in `resources/settings/settings.xml`.
6. Add the behaviour to the appropriate menu in `resources/menu` to make it available via the watch face configuration menu.
7. Add the behaviour to the appropriate maps and lists in `source/ui/views/SettingsMenu.mc`.
8. Register the behaviour in `source/config/Properties.mc`. Be sure to re-use the ID given to the drawable.
9. Implement a new behaviour class in `source/ui/indicators`.
10. Let `source/ui/indicators/IndicatorMeterFactory.mc` know about the new class.

10 steps… Most of this should really be automated…

## Performing a Release

Do this to release a new release:

* Create a new release branch `releases/<version>`
* Update `AppName` in `strings.xml`
* Update the UUID in `manifest.xml`
* Produce a build
* Upload the build to the Connect IQ store
* Do a GitHub release
* Back on the `master` branch, increase the version number in `manifest.xml` to the next planned release number
* Add a new milestone on GitHub

For internal beta releases, simply produce a build from the `master` branch and be done with it.