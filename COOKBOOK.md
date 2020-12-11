# Facey McWatchface Cook Book

Facey McWatchface has become surprisingly complex. This cook book provides a few recipes for common tasks.

## Adding a Indicator / Meter Behaviour

Adding behaviours rather simple if you have a Python 3 installation at hand. Get one and do this:

1. Add your behaviour definition to `source/indicators.json` or `source/meters.json`, whichever is appropriate. Always add new behaviours to the end of the list.
2. Run the `generate_ui.py` script in the project’s root folder. This will register your behaviour in all the necessary places. Boom!
3. Find and add an appropriate icon to `resources/fonts/symbols_font.afdesign`, export the font bitmap and register your icon in `symbols_font.fnt`.
4. Export the new icon as a 32x32 pixel icon in `resources/drawables`. You’ll find the expected file name in the appropriate `drawables_xxx.xml` file.
5. Implement your behaviour by adding a class in `source/ui/indicators` or `source/ui/meters`. The expected class name can be found in the appropriate factory function in `source/generated/XXXFactory.mc`.

## Adding a Colour Theme

Adding colour themes is almost like adding indicator / meter behaviours, but easier. It does, however, also requires a Python 3 installation. Do this:

1. Add your colour theme to `source/themes.json`. Always add new themes to the end of the list.
2. Run the `generate_themes.py` script in the project's root folder.

Done! Yay!

## Performing a Release

Do this to release a new release:

* [ ] Compile release notes in `VERSIONS.md`.
* [ ] Bring `README.md` and `promo/store_description.txt` up to date with the new features.
* [ ] Update screenshots.
* [ ] Create a new release branch `releases/<version>`
* [ ] Update `AppName` in `strings.xml`.
* [ ] Update the UUID in `manifest.xml`.
* [ ] Produce a build.
* [ ] Upload the build to the Connect IQ store.
* [ ] Do a GitHub release.
* [ ] Back on the `master` branch, increase the version number in `manifest.xml` to match the current release, but increase revision appropriately.
* [ ] Add a new milestone on GitHub.
* [ ] Close the released milestone.

For internal beta releases, simply produce a build from the `master` branch and be done with it.