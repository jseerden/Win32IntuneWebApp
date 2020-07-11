# IntuneWinAppUtil
Packaged to IntuneWin with the Microsoft Win32 Content Prep Tool: https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool

Package command used: IntuneWinAppUtil.exe -c '.\Source' -s '.\Source\Add-WebApp.ps1' -o '.\Package'

## Example Win32 App Configuration
Install command: `PowerShell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "Add-WebApp.ps1" -ShortcutName "MyApps" -ShortcutUrl "https://myapps.microsoft.com" -ShortcutIconUrl "https://myintuneiconstorage.blob.core.windows.net/icons/microsoft-myapps.ico" -ShortcutInStartMenu $true -ShortcutOnDesktop $true -ShortcutInStartup $false`

Uninstall command: `PowerShell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "Remove-WebApp.ps1" -ShortcutName "MyApps"`

App can run either in System (for all users) or User (current user only) context.

## Detection rules
Depending on how you deploy the shortcut you can create one or more detection rules.

---
**NOTE**

The .ico file used in the detection rules is always downloaded as `$ShortcutName`.ico

---

### Detection when running in System context
Rules format: Manually configure detection rules

#### If a ShortcutIconUrl was provided
Rule type: `File`  
Path: `%PROGRAMDATA%\Icons`  
File: `My Apps.ico`  
Detection method: `File or folder exists`

#### If ShortcutOnDesktop is set to $true
Rule type: `File`  
Path: `%PUBLIC%\Desktop`  
File: `My Apps.lnk`  
Detection method: `File or folder exists`

#### If ShortcutInStartMenu is set to $true
Rule type: `File`  
Path: `%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs`  
File: `My Apps.lnk`  
Detection method: `File or folder exists`

#### If ShortCutInStartup is set to $true
Rule type: `File`  
Path: `%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\Startup`  
File: `My Apps.lnk`  
Detection method: `File or folder exists`

### Detection when running in User context
Rules format: Manually configure detection rules

#### If a ShortcutIconUrl was provided
Rule type: `File`  
Path: `%APPDATA%\Icons`  
File: `My Apps.ico`  
Detection method: `File or folder exists`

#### If ShortcutOnDesktop is set to $true and using OneDrive Known Folder Move
Rule type: `File`  
Path: `%ONEDRIVE%\Desktop`  
File: `My Apps.lnk`  
Detection method: `File or folder exists`

#### If ShortcutOnDesktop is set to $true and not using OneDrive Known Folder Move
Rule type: `File`  
Path: `%USERPROFILE%\Desktop`  
File: `My Apps.lnk`  
Detection method: `File or folder exists`

#### If ShortcutInStartMenu is set to $true
Rule type: `File`  
Path: `%APPDATA%\Microsoft\Windows\Start Menu\Programs`  
File: `My Apps.lnk`  
Detection method: `File or folder exists`

#### If ShortCutInStartup is set to $true
Rule type: `File`  
Path: `%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup`  
File: `My Apps.lnk`  
Detection method: `File or folder exists`

