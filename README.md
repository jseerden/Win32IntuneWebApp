# IntuneWinAppUtil
Packaged to IntuneWin with the Microsoft Win32 Content Prep Tool: https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool

Package command used: IntuneWinAppUtil.exe -c '.\Source' -s '.\Source\Add-WebApp.ps1' -o '.\Package'

## Example Win32 App Configuration
Install command: `PowerShell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "Add-WebApp.ps1" -ShortcutName "MyApps" -ShortcutUrl "https://myapps.microsoft.com" -ShortcutIconUrl "https://myintuneiconstorage.blob.core.windows.net/icons/microsoft-myapps.ico" -ShortcutInStartMenu $true -ShortcutOnDesktop $true -ShortcutInStartup $false`

Uninstall command: `PowerShell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "Remove-WebApp.ps1" -ShortcutName "MyApps"`

App can run either in System (for all users) or User (current user only) context.

## Detection rules

---
**NOTE**

The .ico file used in the detection rules is always downloaded as `$ShortcutName`.ico

---

### Detection when running in System context
Rules format: Manually configure detection rules

Rule type: `File`  
Path: `%PROGRAMDATA%\Icons`  
File: `My Apps.ico`  
Detection method: `File or folder exists`

Rule type: `File`  
Path: `%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs`  
File: `My Apps.lnk`  
Detection method: `File or folder exists`

### Detection when running in User context
Rules format: Manually configure detection rules

Rule type: `File`  
Path: `%APPDATA%\Icons`  
File: `My Apps.ico`  
Detection method: `File or folder exists`

Rule type: `File`  
Path: `%APPDATA%\Microsoft\Windows\Start Menu\Programs`  
File: `My Apps.lnk`  
Detection method: `File or folder exists`


