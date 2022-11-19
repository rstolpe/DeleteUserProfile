# DeleteUserProfiles
This module will let you show all of the user profiles that are stored on a local or remote computer, you can also delete one specific user profile or all of them.   
### This module will do the following
- Show all of the local user profiles
- Show all of the user profiles from a remote computer
- Delete one specific user profile or all of the user profiles from a local computer
- Delete one specific user profile or all of the user profiles from a remote computer
- Delete all user profiles from both local and remote computer
- You can exclude user profiles to show
- You can exclude user profile to be deleted
- If the user profile are loaded it will not get deleted  
  
If you use this function on a remote computer you need to make sure that you have [WinRM](https://github.com/rstolpe/Guides/blob/main/Windows/WinRM_GPO.md) activated.

### Links
- [YouTube video](https://youtube.com/shorts/SPPSHiMjVmA?feature=share)

# Install
```
Install-Module -Name DeleteUserProfiles
```

# Example
## Get-UserProfiles
### Return all user profiles from the localhost / machine
```
Get-UserProfiles
```
Returns all user profiles that are stored on the local computer

```
Get-UserProfiles -ExcludedProfiles @("Frank", "rstolpe")
```
This will show all of the user profiles stored on the local machine except user profiles that are named Frank and rstolpe

### Return all user profiles from remote machine
```
Get-UserProfiles -ComputerName "Win11-Test"
```
This will return all of the user profiles stored on the remote computer "Win11-test"

```
Get-UserProfiles -ComputerName "Win11-Test" -ExcludedProfiles @("Frank", "rstolpe")
```
This will return all of the user profiles stored on the remote computer "Win11-Test" except user profiles that are named Frank and rstolpe

## Remove-UserProfile