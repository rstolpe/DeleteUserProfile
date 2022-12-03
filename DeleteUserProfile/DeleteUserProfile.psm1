﻿<#
    Copyright (C) 2022 Robin Stolpe. <https://stolpe.io>
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
    #>
#
#
Function Get-RSUserProfile {
    <#
        .SYNOPSIS
        Return all user profiles that are saved on a computer

        .DESCRIPTION
        Return all user profiles that are saved on a local or remote computer and you can also delete one or all of the user profiles, the special windows profiles are excluded.
        You can also show all user profiles from multiple computers at the same time.

        .PARAMETER ComputerName
        The name of the remote computer you want to display all of the user profiles from. If you want to use it on a local computer you don't need to fill this one out.

        .PARAMETER ExcludedProfiles
        All of the usernames you write here will be excluded from the script and they will not show up, it's a array so you can add multiple users like @("User1", "User2")

        .EXAMPLE
        Get-RSUserProfile
        # This will return all of the user profiles saved on the local machine

        .EXAMPLE
        Get-RSUserProfile -ExcludedProfile "Frank, rstolpe"
        # This will return all of the user profiles saved on the local machine except user profiles that are named Frank and rstolpe

        .EXAMPLE
        Get-RSUserProfile -ComputerName "Win11-Test"
        # This will return all of the user profiles saved on the remote computer "Win11-test"

        .EXAMPLE
        Get-RSUserProfile -ComputerName "Win11-Test, Win10"
        # This will return all of the user profiles saved on the remote computers named Win11-Test and Win10

        .EXAMPLE
        Get-RSUserProfile -ComputerName "Win11-Test" -ExcludedProfile "Frank, rstolpe"
        # This will return all of the user profiles saved on the remote computer "Win11-Test" except user profiles that are named Frank and rstolpe

        .LINK
        https://github.com/rstolpe/DeleteUserProfile/blob/main/README.md

        .NOTES
        Author:         Robin Stolpe
        Mail:           robin@stolpe.io
        Twitter:        https://twitter.com/rstolpes
        Linkedin:       https://www.linkedin.com/in/rstolpe/
        Website/Blog:   https://stolpe.io
        GitHub:         https://github.com/rstolpe
        PSGallery:      https://www.powershellgallery.com/profiles/rstolpe
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = "Enter computername on the computer that you to delete user profiles from, multiple names are accepted if separated with ,")]
        [string]$ComputerName = "localhost",
        [Parameter(Mandatory = $false, HelpMessage = "Enter name of user profiles that you want to exclude, multiple input are accepted if separated with ,")]
        [string]$ExcludedProfile
    )
    foreach ($Computer in $ComputerName.Split(",").Trim()) {
        if (Test-WSMan -ComputerName $Computer -ErrorAction SilentlyContinue) {
            Write-Output "`n== All profiles on $($Computer) ==`n"
            try {
                Get-CimInstance -ComputerName $Computer -className Win32_UserProfile | Where-Object { (-Not ($_.Special)) } | Foreach-Object {
                    if (-Not ($_.LocalPath.split('\')[-1] -in $ExcludedProfile)) {
                        [PSCustomObject]@{
                            'UserName'               = $_.LocalPath.split('\')[-1]
                            'Profile path'           = $_.LocalPath
                            'Last used'              = ($_.LastUseTime -as [DateTime]).ToString("yyyy-MM-dd HH:mm")
                            'Is the profile active?' = $_.Loaded
                        }
                    }
                } | Format-Table
            }
            catch {
                Write-Error "$($PSItem.Exception)"
                break
            }
        }
        else {
            Write-Output "$($Computer) are not connected to the network or it's trouble with WinRM"
        }
    }
}
Function Remove-RSUserProfile {
    <#
        .SYNOPSIS
        Let you delete user profiles from a local or remote computer

        .DESCRIPTION
        Let you delete user profiles from a local computer or remote computer, you can also delete all of the user profiles. You can also exclude profiles.
        If the profile are loaded you can't delete it. The special Windows profiles are excluded

        .PARAMETER Computer
        The name of the remote computer you want to display all of the user profiles from. If you want to use it on a local computer you don't need to fill this one out.

        .PARAMETER ProfileToDelete
        If you want to delete just one user profile your specify the username here.

        .PARAMETER DeleteAll
        If you want to delete all of the user profiles on the local or remote computer you can set this to $True or $False

        .EXAMPLE
        Remove-RSUserProfile -DeleteAll
        # This will delete all of the user profiles from the local computer your running the script from.

        .EXAMPLE
        Remove-RSUserProfile -ExcludedProfile "User1, User2" -DeleteAll
        # This will delete all of the user profiles except user profile User1 and User2 on the local computer

        .EXAMPLE
        Remove-RSUserProfile -ProfileToDelete "User1, User2"
        # This will delete only user profile "User1" and "User2" from the local computer where you run the script from.

        .EXAMPLE
        Remove-RSUserProfile -ComputerName "Win11-test" -DeleteAll
        # This will delete all of the user profiles on the remote computer named "Win11-Test"

        .EXAMPLE
        Remove-RSUserProfile -ComputerName "Win11-test" -ExcludedProfile "User1, User2" -DeleteAll
        # This will delete all of the user profiles except user profile User1 and User2 on the remote computer named "Win11-Test"

        .EXAMPLE
        Remove-RSUserProfile -ComputerName "Win11-test" -ProfileToDelete "User1, User2"
        # This will delete only user profile "User1" and "User2" from the remote computer named "Win11-Test"

        .LINK
        https://github.com/rstolpe/DeleteUserProfile/blob/main/README.md

        .NOTES
        Author:         Robin Stolpe
        Mail:           robin@stolpe.io
        Twitter:        https://twitter.com/rstolpes
        Linkedin:       https://www.linkedin.com/in/rstolpe/
        Website/Blog:   https://stolpe.io
        GitHub:         https://github.com/rstolpe
        PSGallery:      https://www.powershellgallery.com/profiles/rstolpe
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = "Enter computername on the computer that you to delete user profiles from, multiple names are accepted if separated with ,")]
        [string]$ComputerName = "localhost",
        [Parameter(Mandatory = $false, HelpMessage = "Enter the userprofile that you want to delete")]
        [string]$ProfileToDelete,
        [Parameter(Mandatory = $false, HelpMessage = "Use if you want to delete all user profiles")]
        [switch]$DeleteAll = $false,
        [Parameter(Mandatory = $false, HelpMessage = "Enter name of user profiles that you want to exclude, multiple input are accepted if separated with ,")]
        [string]$ExcludedProfile
    )

    foreach ($Computer in $ComputerName.Split(",").Trim()) {
        if (Test-WSMan -ComputerName $Computer -ErrorAction SilentlyContinue) {
            if ($DeleteAll -eq $True) {
                foreach ($Profile in $(Get-CimInstance -ComputerName $Computer -className Win32_UserProfile | Where-Object { (-Not ($_.Special)) } | Select-Object LocalPath, Loaded)) {
                    if ($Profile.LocalPath.split('\')[-1] -in $ExcludedProfile) {
                        Write-Output "$($Profile.LocalPath.split('\')[-1]) are excluded so it wont be deleted, proceeding to next profile..."
                    }
                    else {
                        if ($Profile.Loaded -eq $True) {
                            Write-Warning "The user profile $($Profile.LocalPath.split('\')[-1]) is loaded, can't delete it so skipping it!"
                            Continue
                        }
                        else {
                            try {
                                Write-Output "Deleting user profile $($Profile.LocalPath.split('\')[-1])..."
                                Get-CimInstance -ComputerName $Computer Win32_UserProfile | Where-Object { $_.LocalPath -eq $Profile.LocalPath } | Remove-CimInstance
                                Write-Output "The user profile $($Profile.LocalPath.split('\')[-1]) are now deleted!" -ForegroundColor Green
                            }
                            catch {
                                Write-Error "$($PSItem.Exception)"
                                continue
                            }
                        }
                    }
                }
            }
            elseif ($DeleteAll -eq $False) {
                foreach ($user in $ProfileToDelete.Split(",").Trim()) {
                    if ("$env:SystemDrive\Users\$($user)" -in $AllUserProfiles.LocalPath) {
                        # check if the userprofile are loaded and if it is show warning
                        try {
                            Write-Output "Deleting user profile $($user)..."
                            Get-CimInstance -ComputerName $Computer Win32_UserProfile | Where-Object { $_.LocalPath -eq "$env:SystemDrive\Users\$($user)" } | Remove-CimInstance
                            Write-Output "The user profile $($user) are now deleted!" -ForegroundColor Green
                        }
                        catch {
                            Write-Error "$($PSItem.Exception)"
                            Continue
                        }
                    }
                    else {
                        Write-Warning "$($user) did not have any user profile on $($Computer)!"
                        Continue
                    }
                }
            }
        }
        else {
            Write-Output "$($Computer) are not connected to the network or it's trouble with WinRM"
        }
    }
}
