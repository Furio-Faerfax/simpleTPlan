# Changelog

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/) and follows the [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format.

---

## [Unreleased]
- Planning and minor improvements for next release.

---

## [1.1.0] – 2025-06-23
### Added
- A new column to store done tasks, and move them back to the column where they were before
- Automatic time tracking, if you hit the stopwatch icon
- Reposition the tasks in the columns
- Additionaly to the arrows for the time setting, you can now enter the time with the input field, accepted formats: 0 | 0,0 | 0.0 ; other or longer values will be cropped down 

---

## [1.0.2] – 2025-05-19
### Fixed
- On load, time will now be set to the correct planned/is value, same for clear
- If a time card gets deleted, the time will be added back to the remaining times
- fixed min/max blocking in the global time display, but disabled it for now, you can go from 0-24 in planned and is in the time cards, but the time for global display is now going in the negative values

### Added
- Is time, is now saved again, opt in in menu for this feature
- a boolean in the time card for saving if its done or not, feature comes in next feature update

---

## [1.0.1] – 2025-04-21
### Fixed
- Crash on first-time launch of the app.
- Menu required two clicks to reopen after closing the About dialog.
- Typo corrected in the app name in `README.md`.

### Added
- `CHANGELOG.md` file to document release history.

---

## [1.0.0] – 2025-04-21
### Added
- Initial release of the minimalistic time planning app.
- Included the pixel font **ThaleahFat.ttf** by Rick Hoppmann ([CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)).
- LICENSE file with [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).
- NOTICE file including third-party attributions.
- Basic time block layout and core scheduling functionality.
