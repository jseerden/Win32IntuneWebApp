<#
    .SYNOPSIS
        Creates shortcuts to a web app using the default browser.
    .DESCRIPTION
        Author:  John Seerden (https://www.srdn.io)
        Version: 2.0

        Creates shortcuts to a web app, using the default browser, in the Start Menu, Startup folder and/or on the Desktop.
    .PARAMETER ShortcutName
        Display Name of the shortcut.
    .PARAMETER ShortcutUrl
        URL associated with the shortcut.
    .PARAMETER ShortcutOnDesktop
        Set to $true if the shortcut needs to be added to the assigned User's Profile Desktop.
    .PARAMETER ShortcutInStartup
        Set to $true if the shortcut needs to start up automatically after the user has logged on.
    .PARAMETER ShortcutInStartMenu
        Set to $true if the shortcut needs to be added to the assigned User's Start Menu.
    .NOTES
        This script can either run in SYSTEM (for all users) or USER (current user only) context.
    .EXAMPLE
        Add-WebApp.ps1 -ShortcutName MyApps -ShortCutUrl "https://myapps.microsoft.com" -ShortcutIconUrl "https://myintuneicons.blob.core.windows.net/icons/microsoft-myapps.ico" -ShortcutOnDesktop $true -ShortcutInStartup $true -ShortcutInStartMenu $true
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$ShortcutName,

    [Parameter(Mandatory = $true)]
    [string]$ShortcutUrl,

    [Parameter(Mandatory = $false)]
    [string]$ShortcutIconUrl,
    
    [Parameter(Mandatory = $false)]
    [string]$ShortcutOnDesktop = $false,

    [Parameter(Mandatory = $false)]
    [string]$ShortcutInStartup = $false,

    [Parameter(Mandatory = $false)]
    [string]$ShortcutInStartMenu = $true
)

# Allows for providing string values from Intune install/uninstall cmdlets, that are then converted to booleans.
[bool]$ShortcutOnDesktop = [System.Convert]::ToBoolean($ShortcutOnDesktop)
[bool]$ShortcutInStartup = [System.Convert]::ToBoolean($ShortcutInStartup)
[bool]$ShortcutInStartMenu = [System.Convert]::ToBoolean($ShortcutInStartMenu)

$WScriptShell = New-Object -ComObject WScript.Shell

# Check if running in SYSTEM context (Shortcut applies for all users)
if ([Security.Principal.WindowsIdentity]::GetCurrent().Name -eq "NT AUTHORITY\SYSTEM") {

    if ($ShortcutIconUrl) {
        if (-not (Test-Path "$($env:ProgramData)\Icons")) {
            New-Item -Path "$($env:ProgramData)\Icons" -ItemType Directory
        }

        # Let's remove the existing shortcut, in case we want to replace it with a newer one.
        if (Test-Path "$($env:ProgramData)\Icons\$ShortcutName.ico") {
            Remove-Item "$($env:ProgramData)\Icons\$ShortcutName.ico" -Force
        }

        # Download the shortcut
        (New-Object System.Net.WebClient).DownloadFile($ShortcutIconUrl, "$($env:ProgramData)\Icons\$ShortcutName.ico")

        $ShortcutIconLocation = "$($env:ProgramData)\Icons\$ShortcutName.ico"
    }

    if ($ShortcutOnDesktop) {
        $Shortcut = $WScriptShell.CreateShortcut("$env:PUBLIC\Desktop\$ShortcutName.lnk") 
        $Shortcut.TargetPath = $ShortcutUrl
        if ($ShortcutIconLocation) {
            $Shortcut.IconLocation = $ShortcutIconLocation
        }
        $Shortcut.Save()
    }

    if ($ShortcutInStartup) {
        $Shortcut = $WScriptShell.CreateShortcut("$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\Startup\$ShortcutName.lnk") 
        $Shortcut.TargetPath = $ShortcutUrl
        if ($ShortcutIconLocation) {
            $Shortcut.IconLocation = $ShortcutIconLocation
        }
        $Shortcut.Save()
    }

    if ($ShortCutInStartMenu) {
        $Shortcut = $WScriptShell.CreateShortcut("$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\$ShortcutName.lnk") 
        $Shortcut.TargetPath = $ShortcutUrl 
        if ($ShortcutIconLocation) {
            $Shortcut.IconLocation = $ShortcutIconLocation
        }
        $Shortcut.Save()
    }
}
# Running in USER context (Shortcut only applies for the logged on user)
else {
    if ($ShortcutIconUrl) {
        if (-not (Test-Path "$($env:AppData)\Icons")) {
            New-Item -Path "$($env:AppData)\Icons" -ItemType Directory
        }

        # Let's remove the existing shortcut, in case we want to replace it with a newer one.
        if (Test-Path "$($env:AppData)\Icons\$ShortcutName.ico") {
            Remove-Item "$($env:AppData)\Icons\$ShortcutName.ico" -Force
        }

        # Download the shortcut
        (New-Object System.Net.WebClient).DownloadFile($ShortcutIconUrl, "$($env:AppData)\Icons\$ShortcutName.ico")

        $ShortcutIconLocation = "$($env:AppData)\Icons\$ShortcutName.ico"
    }

    # Check whether or not the Desktop is moved with OneDrive Known Folder Move and place the Shortcut there.
    if ($ShortcutOnDesktop) {
        $Shortcut = $WScriptShell.CreateShortcut("$([Environment]::GetFolderPath("Desktop"))\$ShortcutName.lnk") 
        $Shortcut.TargetPath = $ShortcutUrl
        if ($ShortcutIconLocation) {
            $Shortcut.IconLocation = $ShortcutIconLocation
        }
        $Shortcut.Save()
    }

    if ($ShortcutInStartup) {
        $Shortcut = $WScriptShell.CreateShortcut("$env:AppData\Microsoft\Windows\Start Menu\Programs\Startup\$ShortcutName.lnk") 
        $Shortcut.TargetPath = $ShortcutUrl
        if ($ShortcutIconLocation) {
            $Shortcut.IconLocation = $ShortcutIconLocation
        }
        $Shortcut.Save()
    }

    if ($ShortCutInStartMenu) {
        $Shortcut = $WScriptShell.CreateShortcut("$env:AppData\Microsoft\Windows\Start Menu\Programs\$ShortcutName.lnk") 
        $Shortcut.TargetPath = $ShortcutUrl 
        if ($ShortcutIconLocation) {
            $Shortcut.IconLocation = $ShortcutIconLocation
        }
        $Shortcut.Save()
    }
}
