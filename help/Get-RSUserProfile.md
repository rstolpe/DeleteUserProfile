
NAME
    Get-RSUserProfile
    
SYNOPSIS
    Return all user profiles that are saved on a computer
    
    
SYNTAX
    Get-RSUserProfile [[-ComputerName] <String[]>] [[-Exclude] <String[]>] [<CommonParameters>]
    
    
DESCRIPTION
    Return all user profiles that are saved on a local or remote computer and you can also delete one or all of the user profiles, the special windows profiles are excluded.
    You can also show all user profiles from multiple computers at the same time.
    

PARAMETERS
    -ComputerName <String[]>
        The name of the remote computer you want to display all of the user profiles from. If you want to use it on a local computer you don't need to fill this one out.
        You can add multiple computers like this: -ComputerName "Win11-Test", "Win10"
        
        Required?                    false
        Position?                    1
        Default value                localhost
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
INPUTS
    
OUTPUTS
    
NOTES
    
    
        Author:         Robin Stolpe
        Mail:           robin@stolpe.io
        Twitter:        https://twitter.com/rstolpes
        Linkedin:       https://www.linkedin.com/in/rstolpe/
        Website/Blog:   https://stolpe.io
        GitHub:         https://github.com/rstolpe
        PSGallery:      https://www.powershellgallery.com/profiles/rstolpe
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > Get-RSUserProfile
    # This will return all of the user profiles saved on the local machine
    
       
    -------------------------- EXAMPLE 2 --------------------------
    
    PS > Get-RSUserProfile -ComputerName "Win11-Test"
    # This will return all of the user profiles saved on the remote computer "Win11-test"
    
       
    -------------------------- EXAMPLE 3 --------------------------
    
    PS > Get-RSUserProfile -ComputerName "Win11-Test", "Win10"
    # This will return all of the user profiles saved on the remote computers named Win11-Test and Win10
    
    
    
    
RELATED LINKS
    https://github.com/rstolpe/DeleteUserProfile/blob/main/README.md


