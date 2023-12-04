Function Get-RSUserProfile {
    <#
        .SYNOPSIS
        Return all user profiles that are saved on a computer

        .DESCRIPTION
        Return all user profiles that are saved on a local or remote computer and you can also delete one or all of the user profiles, the special windows profiles are excluded.
        You can also show all user profiles from multiple computers at the same time.

        .PARAMETER ComputerName
        The name of the remote computer you want to display all of the user profiles from. If you want to use it on a local computer you don't need to fill this one out.
        You can add multiple computers like this: -ComputerName "Win11-Test", "Win10"

        .EXAMPLE
        Get-RSUserProfile
        # This will return all of the user profiles saved on the local machine

        .EXAMPLE
        Get-RSUserProfile -ComputerName "Win11-Test"
        # This will return all of the user profiles saved on the remote computer "Win11-test"

        .EXAMPLE
        Get-RSUserProfile -ComputerName "Win11-Test", "Win10"
        # This will return all of the user profiles saved on the remote computers named Win11-Test and Win10

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
        [Parameter(Mandatory = $false, HelpMessage = "Enter name of the computer or computers you want to collect user profiles from, multiple computername are supported.")]
        [string[]]$ComputerName = "localhost"
    )
    
    foreach ($_computer in $ComputerName) {
        if (Test-WSMan -ComputerName $_computer -ErrorAction SilentlyContinue) {
            Write-Output "`n=== All profiles on $_computer ===`n"

            try {
                # Collect all user profiles
                $GetUserData = Get-CimInstance -ComputerName $_computer -className Win32_UserProfile | Where-Object -Not Special | Select-Object LocalPath, LastUseTime, Loaded | Sort-Object -Descending -Property LastUseTime
                $UserProfileData = foreach ($_profile in $GetUserData) {

                    # Calculate how long it was the profile was used
                    if (-Not([string]::IsNullOrEmpty($_profile.LastUseTime))) {
                        $NotUsed = NEW-TIMESPAN -Start $_profile.LastUseTime -End (Get-Date) | Select-Object days, hours, Minutes  | Foreach-Object {
                            [PSCustomObject]@{
                                days    = if ($Null -eq $_.Days -or $_.Days -eq "0") { $Null } else { $_.Days }
                                hours   = if ($Null -eq $_.Hours -or $_.Hours -eq "0") { $Null } else { $_.Hours }
                                minutes = if ($Null -eq $_.Minutes -or $_.Minutes -eq "0") { $Null } else { $_.Minutes }
                            }
                        }
                    }

                    [PSCustomObject]@{
                        ProfileUserName = if ($null -ne $_profile.LocalPath) { $_profile.LocalPath.split('\')[-1] }
                        ProfilePath     = if ($null -ne $_profile.LocalPath) { $_profile.LocalPath }
                        LastUsed        = if ($null -ne $_profile.LastUseTime) { ($_profile.LastUseTime -as [DateTime]).ToString("yyyy-MM-dd HH:mm") }
                        ProfileLoaded   = if ($null -ne $_profile.Loaded) { $_profile.Loaded }
                        NotUsed         = if (-Not([string]::IsNullOrEmpty($NotUsed))) { $NotUsed } else { "N/A" }
                    }
                }

                if ($null -ne $UserProfileData) {
                    return $UserProfileData
                }
                else {
                    Write-Output "No user profiles found on $_computer"
                }
            }
            catch {
                Write-Output "$($PSItem.Exception.Message)"
            }
        }
        else {
            Write-Output "$_computer are not connected to the network or it's trouble with WinRM"
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

        .PARAMETER ComputerName
        The name of the remote computer you want to display all of the user profiles from. If you want to use it on a local computer you don't need to fill this one out.

        .PARAMETER Delete
        If you want to delete just one user profile your specify the username here.

        .PARAMETER DeleteAll
        If you want to delete all of the user profiles on the local or remote computer you can set this to $True or $False

        .EXAMPLE
        Remove-RSUserProfile -DeleteAll
        # This will delete all of the user profiles from the local computer your running the script from.

        .EXAMPLE
        Remove-RSUserProfile -Exclude "User1", "User2" -DeleteAll
        # This will delete all of the user profiles except user profile User1 and User2 on the local computer

        .EXAMPLE
        Remove-RSUserProfile -Delete "User1", "User2"
        # This will delete only user profile "User1" and "User2" from the local computer where you run the script from.

        .EXAMPLE
        Remove-RSUserProfile -ComputerName "Win11-test" -DeleteAll
        # This will delete all of the user profiles on the remote computer named "Win11-Test"

        .EXAMPLE
        Remove-RSUserProfile -ComputerName "Win11-test" -Exclude "User1", "User2" -DeleteAll
        # This will delete all of the user profiles except user profile User1 and User2 on the remote computer named "Win11-Test"

        .EXAMPLE
        Remove-RSUserProfile -ComputerName "Win11-test" -Delete "User1", "User2"
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
        [Parameter(Mandatory = $false, HelpMessage = "Enter computername on the computer that you to delete user profiles from, multiple names are supported")]
        [string[]]$ComputerName = "localhost",
        [Parameter(Mandatory = $false, HelpMessage = "Enter the name of the user profiles that you want to delete, multiple names are supported")]
        [string[]]$Delete,
        [Parameter(Mandatory = $false, HelpMessage = "Use if you want to delete all user profiles")]
        [switch]$DeleteAll = $false,
        [Parameter(Mandatory = $false, HelpMessage = "Enter name of user profiles that you want to exclude, multiple names are supported")]
        [string[]]$Exclude
    )

    foreach ($Computer in $ComputerName) {
        if (Test-WSMan -ComputerName $Computer -ErrorAction SilentlyContinue) {
            $AllUserProfiles = Get-CimInstance -ComputerName $Computer -className Win32_UserProfile | Where-Object { (-Not ($_.Special)) } | Select-Object LocalPath, Loaded
            if ($DeleteAll -eq $true) {
                foreach ($Profile in $($AllUserProfiles)) {
                    if ($Profile.LocalPath.split('\')[-1] -in $Exclude) {
                        Write-Output "$($Profile.LocalPath.split('\')[-1]) are excluded so it wont be deleted, proceeding to next profile..."
                    }
                    else {
                        if ($Profile.Loaded -eq "true") {
                            Write-Warning "The user profile $($Profile.LocalPath.split('\')[-1]) is loaded, can't delete it so skipping it!"
                            Continue
                        }
                        else {
                            try {
                                Write-Output "Deleting user profile $($Profile.LocalPath.split('\')[-1])..."
                                Get-CimInstance -ComputerName $Computer Win32_UserProfile | Where-Object { $_.LocalPath -eq $Profile.LocalPath } | Remove-CimInstance
                                Write-Output "The user profile $($Profile.LocalPath.split('\')[-1]) are now deleted!"
                            }
                            catch {
                                Write-Error "$($PSItem.Exception)"
                                continue
                            }
                        }
                    }
                }
            }
            elseif ($DeleteAll -eq $false -and $null -ne $Delete) {
                foreach ($user in $Delete) {
                    if ("$env:SystemDrive\Users\$user" -in $AllUserProfiles.LocalPath) {
                        if ($Profile.LocalPath.split('\')[-1] -in $Exclude) {
                            Write-Output "$($Profile.LocalPath.split('\')[-1]) are excluded so it wont be deleted..."
                        }
                        else {
                            try {
                                Write-Output "Deleting user profile $user..."
                                Get-CimInstance -ComputerName $Computer Win32_UserProfile | Where-Object { $_.LocalPath -eq "$env:SystemDrive\Users\$user" } | Remove-CimInstance
                                Write-Output "The user profile $user are now deleted!"
                            }
                            catch {
                                Write-Error "$($PSItem.Exception)"
                                Continue
                            }
                        }
                    }
                    else {
                        Write-Warning "$user did not have any user profile on $Computer!"
                        Continue
                    }
                }
            }
        }
        else {
            Write-Output "$Computer are not connected to the network or it's trouble with WinRM"
        }
    }
}