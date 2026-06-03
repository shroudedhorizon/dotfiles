# Setup

For Windows, just use the [Chris Titus Windows Utility](https://christitus.com/windows-tool/). Make sure to run in Powershell, with Admin access.

```powershell
iwr -useb https://christitus.com/win | iex
```

## Usage

Once the tool is running, import the settings-ctt.json into the tool, then hit Install to install all of the apps, and make sure to apply the tweaks as well.

After that is done, make sure to run PowerToys, and import the settings for that as well.

## Notes
#### Stop Mouse from Waking PC
1. Go to Device Manager
2. Unplug keyboard
3. Under `Keyboards` and `Mice and other pointing devices`, go through all devices and under `Power Management` disable the option that allows the device to wake the computer.
