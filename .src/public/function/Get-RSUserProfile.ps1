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

        .PARAMETER Exclude
        All of the usernames you write here will be excluded from the script and they will not show up, it's a array so you can add multiple users like this: -Exclude "User1", "User2"

        .EXAMPLE
        Get-RSUserProfile
        # This will return all of the user profiles saved on the local machine

        .EXAMPLE
        Get-RSUserProfile -Exclude "Frank", "rstolpe"
        # This will return all of the user profiles saved on the local machine except user profiles that are named Frank and rstolpe

        .EXAMPLE
        Get-RSUserProfile -ComputerName "Win11-Test"
        # This will return all of the user profiles saved on the remote computer "Win11-test"

        .EXAMPLE
        Get-RSUserProfile -ComputerName "Win11-Test", "Win10"
        # This will return all of the user profiles saved on the remote computers named Win11-Test and Win10

        .EXAMPLE
        Get-RSUserProfile -ComputerName "Win11-Test" -Exclude "Frank", "rstolpe"
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
        [Parameter(Mandatory = $false, HelpMessage = "Enter computername on the computer that you to delete user profiles from, multiple names are supported")]
        [string[]]$ComputerName = "localhost",
        [Parameter(Mandatory = $false, HelpMessage = "Enter name of user profiles that you want to exclude, multiple names are supported")]
        [string[]]$Exclude
    )
    foreach ($Computer in $ComputerName) {
        if (Test-WSMan -ComputerName $Computer -ErrorAction SilentlyContinue) {
            Write-Output "`n== All profiles on $($Computer) ==`n"
            try {
                Get-CimInstance -ComputerName $Computer -className Win32_UserProfile | Where-Object { (-Not ($_.Special)) } | Foreach-Object {
                    if (-Not ($_.LocalPath.split('\')[-1] -in $Exclude)) {
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