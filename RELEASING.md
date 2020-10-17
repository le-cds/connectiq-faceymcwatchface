# Release Checklist

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