<#
    .SYNOPSIS
        Removes shortcuts to a web app.
    .DESCRIPTION
        Author:  John Seerden (https://www.srdn.io)
        Version: 2.0

        Removes shortcuts to a web app from the Start Menu, Startup folder and Desktop.
    .PARAMETER ShortcutName
        Display Name of the shortcut to remove.
    .NOTES
        This script can either run in SYSTEM (for all users) or USER (current user only) context. It will remove the shortcut from all locations if found, and the corresponding .ico from the %ProgramData%\Icons directory.
    .EXAMPLE
        Remove-WebApp.ps1 -ShortcutName MyApps
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$ShortcutName
)

# Check if running in SYSTEM context (Shortcut applies for all users)
if ([Security.Principal.WindowsIdentity]::GetCurrent().Name -eq "NT AUTHORITY\SYSTEM") {
    # Remove the icon, if exists
    if (Test-Path "$($env:ProgramData)\Icons\$ShortcutName.ico") {
        Remove-Item "$($env:ProgramData)\Icons\$ShortcutName.ico" -Force
    }

    # Remove from desktop, if exists
    if (Test-Path "$env:PUBLIC\Desktop\$ShortcutName.lnk") {
        Remove-Item "$env:PUBLIC\Desktop\$ShortcutName.lnk" -Force
    }

    # Remove from startup, if exists.
    if (Test-Path "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\Startup\$ShortcutName.lnk") {
        Remove-Item "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\Startup\$ShortcutName.lnk" -Force
    }

    # Remove from start menu, if exists.
    if (Test-Path "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\$ShortcutName.lnk") {
        Remove-Item "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\$ShortcutName.lnk" -Force
    }
}
# Running in USER context (Shortcut only applies for the logged on user)
else {
    # Remove the icon, if exists
    if (Test-Path "$($env:AppData)\Icons\$ShortcutName.ico") {
        Remove-Item "$($env:AppData)\Icons\$ShortcutName.ico" -Force
    }

    # Remove from desktop, if exists
    if (Test-Path "$([Environment]::GetFolderPath("Desktop"))\$ShortcutName.lnk") {
        Remove-Item "$([Environment]::GetFolderPath("Desktop"))\$ShortcutName.lnk" -Force
    }

    # Remove from startup, if exists.
    if (Test-Path "$env:AppData\Microsoft\Windows\Start Menu\Programs\Startup\$ShortcutName.lnk") {
        Remove-Item "$env:AppData\Microsoft\Windows\Start Menu\Programs\Startup\$ShortcutName.lnk" -Force
    }

    # Remove from start menu, if exists.
    if (Test-Path "$env:AppData\Microsoft\Windows\Start Menu\Programs\$ShortcutName.lnk") {
        Remove-Item "$env:AppData\Microsoft\Windows\Start Menu\Programs\$ShortcutName.lnk" -Force
    }
}
