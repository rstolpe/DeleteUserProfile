# DeleteUserProfile
This module will let you show all of the user profiles that are saved on a local or remote computer, you can also delete one specific user profile or all of the profiles.  
You can also return the user profiles from multiple computers at the same time.  
The special windows profiles are excluded.
### This module will do the following
- Return all of the user profiles from a remote or local computer
- Delete one specific user profile or all of the user profiles from a local or remote computer
- Delete all user profiles from both local and remote computer
- You can exclude user profiles to show
- You can exclude user profile to be deleted
- If the user profile are loaded it will not get deleted
- The special windows profiles are excluded
  
If you use this module on a remote computer you need to make sure that you have [WinRM](https://github.com/rstolpe/Guides/blob/main/Windows/WinRM_GPO.md) activated.

### Links
- [YouTube video](https://youtube.com/shorts/SPPSHiMjVmA?feature=share)

# Install
```
Install-Module -Name DeleteUserProfile
```

# Example
## Get-UserProfile
If you want to use this on a remote computer just add the parameter ```-ComputerName <COMPUTERNAME>``` in the commands below.  
  
```
Get-UserProfile
```
Return all user profiles that are saved on the local computer

```
Get-UserProfile -ExcludedProfile @("Frank", "rstolpe")
```
This will return all of the user profiles saved on the local machine except user profiles that are named Frank and rstolpe

```
Get-UserProfile -ComputerName "Win11-Test, Win10"
```
This will return all of the user profiles saved on the remote computers named Win11-Test and Win10

## Remove-UserProfile
If you want to use this on a remote computer just add the parameter ```-ComputerName <COMPUTERNAME>``` in the commands below.  
  
```
Remove-UserProfile -DeleteAll
```
This will delete all of the user profiles from the localhost / computer your running the module from.

```
Remove-UserProfile -ExcludedProfile @("User1", "User2") -DeleteAll
```
This will delete all of the user profiles except user profile User1 and User2 on the local computer

```
Remove-UserProfile -ProfileToDelete "User1, User2"
```
This will delete only user profile "User1" and "User2" from the local computer where you run the script from.