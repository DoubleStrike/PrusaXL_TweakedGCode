# PrusaXL_TweakedGCode
A set of well-tested G-Code tweaks to allow for optimal operation of a Prusa XL printer.

This repo contains what I believe are saner, more reasonable starting GCode options for the Prusa XL printer. Where possible, I have made comments to show why I made certain changes. These changes include lowered temps for bed probing, an option for extended pre-heat, and better use of idle temp settings. These have been tested by me on a 5-toolhead machine, but the code is intended to work across all printhead configurations (1, 2, and 5 head).

## Basis for GCode
These codes are usually based on the defaults from the PrusaSlicer config for the XL. They are based on the 6.2.6 firmware code, knowing that the 6.4.x firmwares for the XL still have several known issues. For reliable production work, I strongly recommend avoiding 6.4.x until it is proven stable and all known toolhead crashes, phase stepping, and false filament jam detection issues are resolved.

## Impact on the Prusa XL+
Prusa has recently released a minor model upgrade for the XL that, frankly, addresses core design issues that should have been there day 1, including a nozzle wiper and better belts. The price for this upgrade is extremely high, almost the same cost as a full Snapmaker U1. For those of us who don't have the disposable income and 8 hours to modify our printers, I'll keep the nozzle wiper code in the Start GCode using Surfalex's front-of-bed brass brush wiper.

## License
Please note the AGPLv3 license, and if you use this as part of a video/article/reddit post/derivative content, please reference this repo. Also, please feel free to offer suggestions as pull requests or bugs. Any company using any or all of this GCode in their products must disclose this as a source, and publish all derivative work, without exception.

## Submitting Pull Requests (PRs)
If you have ideas for better G-Code, please submit them as files in the "testing" directory only. **Any PRs that add new files to other folders will be rejected/closed.** If you do not know how to submit a PR, it's super easy and a simple web search will walk you through it step by step.
