
NAME
    Remove-RSUserProfile
    
SYNOPSIS
    Let you delete user profiles from a local or remote computer
    
    
SYNTAX
    Remove-RSUserProfile [[-ComputerName] <String[]>] [[-Delete] <String[]>] [-DeleteAll] [[-Exclude] <String[]>] [<CommonParameters>]
    
    
DESCRIPTION
    Let you delete user profiles from a local computer or remote computer, you can also delete all of the user profiles. You can also exclude profiles.
    If the profile are loaded you can't delete it. The special Windows profiles are excluded
    

PARAMETERS
    -ComputerName <String[]>
        The name of the remote computer you want to display all of the user profiles from. If you want to use it on a local computer you don't need to fill this one out.
        
        Required?                    false
        Position?                    1
        Default value                localhost
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -Delete <String[]>
        If you want to delete just one user profile your specify the username here.
        
        Required?                    false
        Position?                    2
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -DeleteAll [<SwitchParameter>]
        If you want to delete all of the user profiles on the local or remote computer you can set this to $True or $False
        
        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -Exclude <String[]>
        
        Required?                    false
        Position?                    3
        Default value                
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
    
    PS > Remove-RSUserProfile -DeleteAll
    # This will delete all of the user profiles from the local computer your running the script from.
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS > Remove-RSUserProfile -Exclude "User1", "User2" -DeleteAll
    # This will delete all of the user profiles except user profile User1 and User2 on the local computer
    
    
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS > Remove-RSUserProfile -Delete "User1", "User2"
    # This will delete only user profile "User1" and "User2" from the local computer where you run the script from.
    
    
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS > Remove-RSUserProfile -ComputerName "Win11-test" -DeleteAll
    # This will delete all of the user profiles on the remote computer named "Win11-Test"
    
    
    
    
    
    
    -------------------------- EXAMPLE 5 --------------------------
    
    PS > Remove-RSUserProfile -ComputerName "Win11-test" -Exclude "User1", "User2" -DeleteAll
    # This will delete all of the user profiles except user profile User1 and User2 on the remote computer named "Win11-Test"
    
    
    
    
    
    
    -------------------------- EXAMPLE 6 --------------------------
    
    PS > Remove-RSUserProfile -ComputerName "Win11-test" -Delete "User1", "User2"
    # This will delete only user profile "User1" and "User2" from the remote computer named "Win11-Test"
    
    
    
    
    
    
    
RELATED LINKS
    https://github.com/rstolpe/DeleteUserProfile/blob/main/README.md


