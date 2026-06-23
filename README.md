# PrusaXL_TweakedGCode
A set of well-tested G-Code tweaks to allow for optimal operation of a Prusa XL printer.

This repo contains what I believe are saner, more reasonable starting GCode options for the Prusa XL printer. Where possible, I have made comments to show why I made certain changes. These changes include lowered temps for bed probing, an option for extended pre-heat, and better use of idle temp settings. These have been tested by me on a 5-toolhead machine, but the code is intended to work across all printhead configurations (1, 2, and 5 head).

## Basis for GCode
These codes are usually based on the defaults from the PrusaSlicer config for the XL. They are based on the 6.2.6 firmware code, knowing that the 6.4.x firmwares for the XL still have several known issues. For reliable production work, I strongly recommend avoiding 6.4.x until it is proven stable and all known toolhead crashes, phase stepping, and false filament jam detection issues are resolved.

## License
Please note the AGPLv3 license, and if you use this as part of a video/article/reddit post/derivative content, please reference this repo. Also, please feel free to offer suggestions as pull requests or bugs. Any company using any or all of this GCode in their products must disclose this as a source, and publish all derivative work, without exception.

## Submitting Pull Requests (PRs)
If you have ideas for better G-Code, please submit them as files in the "testing" directory only. **Any PRs that add new files to other folders will be rejected/closed.**
