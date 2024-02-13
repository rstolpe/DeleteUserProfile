﻿Function Get-RSUserProfile {
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
        Blog:           https://stolpe.io
        Twitter:        https://twitter.com/rstolpes
        Linkedin:       https://www.linkedin.com/in/rstolpe/
        GitHub:         https://github.com/rstolpe
        PSGallery:      https://www.powershellgallery.com/profiles/rstolpe
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = "Enter name of the computer or computers you want to collect user profiles from, multiple computer names are supported.")]
        [string[]]$ComputerName = "localhost"
    )
    
    $JobGetProfile = foreach ($_computer in $ComputerName) {
        Start-ThreadJob -Name $_computer -ThrottleLimit 50 -ScriptBlock {
            $CheckComputer = $(try { Test-WSMan -ComputerName $Using:_computer -ErrorAction SilentlyContinue } catch { $null })
            if ($null -ne $CheckComputer) {
                try {
                    # Open CIM Session
                    $CimSession = $(try { New-CimSession -ComputerName $Using:_computer -ErrorAction SilentlyContinue } catch { $null })

                    if ($null -ne $CimSession) {
                        # Collect all user profiles
                        $GetUserData = Get-CimInstance -CimSession $CimSession -className Win32_UserProfile | Where-Object { $_.Special -eq $false } | Select-Object LocalPath, LastUseTime, Loaded | Sort-Object -Descending -Property LastUseTime
                    
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
                            Write-Output "No user profiles found on $($Using:_computer)"
                            continue
                        }
                    }
                    else {
                        Write-Output "Could not connect to $($Using:_computer) trough WinRM, please check the connection and try again"
                        continue
                    }
                }
                catch {
                    Write-Output "$($PSItem.Exception.Message)"
                    continue
                }
            }
            else {
                Write-Output "Could not establish connection against $($Using:_computer)"
                continue
            }
        }
    }

    $ReturnProfiles = Receive-Job $JobGetProfile -AutoRemoveJob -Wait
    $ReturnProfiles
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

        .PARAMETER UserName
        If you want to delete specific user profiles you can enter the username here.

        .PARAMETER All
        If you want to delete all of the user profiles on the local or remote computer you can use this switch

        .EXAMPLE
        Remove-RSUserProfile -All
        # This will delete all of the user profiles from the local computer your running the script from. Beside special and loaded profiles

        .EXAMPLE
        Remove-RSUserProfile -Exclude "User1", "User2" -All
        # This will delete all of the user profiles except user profile User1 and User2 on the local computer

        .EXAMPLE
        Remove-RSUserProfile -UserName "User1", "User2"
        # This will delete only user profile "User1" and "User2" from the local computer where you run the script from if the profile are not loaded.

        .EXAMPLE
        Remove-RSUserProfile -ComputerName "Win11-test" -All
        # This will delete all of the user profiles that are not special or loaded on the remote computer named "Win11-Test"

        .EXAMPLE
        Remove-RSUserProfile -ComputerName "Win11-test" -Exclude "User1", "User2" -All
        # This will delete all of the user profiles except user profile User1 and User2 on the remote computer named "Win11-Test" if the profile are not loaded

        .EXAMPLE
        Remove-RSUserProfile -ComputerName "Win11-test" -UserName "User1", "User2"
        # This will delete only user profile "User1" and "User2" from the remote computer named "Win11-Test" if the profile are not loaded

        .LINK
        https://github.com/rstolpe/DeleteUserProfile/blob/main/README.md

        .NOTES
        Author:         Robin Stolpe
        Mail:           robin@stolpe.io
        Blog:           https://stolpe.io
        Twitter:        https://twitter.com/rstolpes
        Linkedin:       https://www.linkedin.com/in/rstolpe/
        GitHub:         https://github.com/rstolpe
        PSGallery:      https://www.powershellgallery.com/profiles/rstolpe
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = "Enter computer name on the computer that you to delete user profiles from, multiple names are supported")]
        [string[]]$ComputerName = "localhost",
        [Parameter(Mandatory = $false, HelpMessage = "Enter the name of the user profiles that you want to delete, multiple names are supported")]
        [string[]]$UserName,
        [Parameter(Mandatory = $false, HelpMessage = "Use this switch if you want to delete all user profiles on the computer")]
        [switch]$All = $false,
        [Parameter(Mandatory = $false, HelpMessage = "Enter username of the user profiles that you want to exclude, multiple names are supported")]
        [string[]]$Exclude
    )

    if ($null -eq $UserName -and $All -eq $false) {
        Write-Output "You must enter a username or use the switch -All to delete user profiles!"
        break
    }

    foreach ($_computer in $ComputerName) {
        $CheckComputer = $(try { Test-WSMan -ComputerName $_computer -ErrorAction SilentlyContinue } catch { $null })
        if ($null -ne $CheckComputer) {
            # Open CIM Session
            $CimSession = $(try { New-CimSession -ComputerName $_computer -ErrorAction SilentlyContinue } catch { $null })
            # Collecting all user profiles on the computer
            if ($null -ne $CimSession) {
                $GetAllProfiles = Get-CimInstance -CimSession $CimSession -ClassName Win32_UserProfile | Where-Object { $_.Special -eq $false }

                if ($null -ne $GetAllProfiles) {
                    # Deleting all user profiles on the computer besides them that are special or loaded
                    if ($All -eq $true) {
                        $JobDelete = foreach ($_profile in $GetAllProfiles) {
                            $UserNameFromPath = $_profile.LocalPath.split('\')[-1]

                            # Starting thread job to speed things up
                            Start-ThreadJob -Name $UserNameFromPath -ThrottleLimit 50 -ScriptBlock {
                                if ($Using:UserNameFromPath -in $Using:Exclude) {
                                    Write-Output "$($Using:UserNameFromPath) are excluded so it wont be deleted, proceeding to next profile..."
                                }
                                else {
                                    if ($Using:_profile.Loaded -eq $true) {
                                        Write-Warning "$($Using:UserNameFromPath) user profile is loaded, can't delete it so skipping it!"
                                        Continue
                                    }
                                    else {
                                        try {
                                            Write-Output "Deleting user profile $($Using:UserNameFromPath)..."
                                            $Using:_profile | Remove-CimInstance
                                            Write-Output "User profile $($Using:UserNameFromPath) are now deleted!"
                                        }
                                        catch {
                                            Write-Error "$($PSItem.Exception)"
                                            continue
                                        }
                                    }
                                }
                            }
                        }

                        $ReturnProfileJob = Receive-Job $JobDelete -AutoRemoveJob -Wait
                        $CimSession | Remove-CimSession
                        $ReturnProfileJob
                    }
                    # if you don't want to delete all profiles but just one or more
                    elseif ($All -eq $false -and $null -ne $UserName) {
                        $JobDelete = foreach ($_profile in $UserName) {
                            Start-ThreadJob -Name $_profile -ThrottleLimit 50 -ScriptBlock {
                                # Adding it to it's own variable to be able to use it in the thread job
                                $GetAllProfile = $Using:GetAllProfiles

                                if ("$($env:SystemDrive)\Users\$($Using:_profile)" -in $GetAllProfile.LocalPath) {
                                    if ($Using:_profile -in $Using:Exclude) {
                                        Write-Output "$($Using:_profile) are excluded so it wont be deleted..."
                                    }
                                    else {
                                        Write-Output "Deleting user profile $($Using:_profile)..."
                                        try {
                                            $Using:_profile | Remove-CimInstance
                                            Write-Output "The user profile $($Using:_profile) are now deleted!"
                                        }
                                        catch {
                                            Write-Error "$($PSItem.Exception)"
                                            continue
                                        }
                                    }
                                }
                                else {
                                    Write-Warning "$($Using:_profile) did not have any user profile on $($Using:_computer)!"
                                    continue
                                }
                            }
                        }

                        $ReturnProfileJob = Receive-Job $JobDelete -AutoRemoveJob -Wait
                        $CimSession | Remove-CimSession
                        $ReturnProfileJob
                    }
                }
                else {
                    Write-Output "No user profiles found on $($_computer)"
                    continue
                }
            }
            else {
                Write-Output "Could not connect to $($_computer) trough WinRM, please check the connection and try again"
                continue
            }
        }
        else {
            Write-Output "Could not establish connection against $($_computer)"
            continue
        }
    }
}