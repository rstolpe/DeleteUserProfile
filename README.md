![GitHub](https://img.shields.io/github/license/rstolpe/DeleteUserProfile?style=plastic)  
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/rstolpe/DeleteUserProfile?sort=semver&style=plastic)  ![Last release](https://img.shields.io/github/release-date/rstolpe/DeleteUserProfile?style=plastic)
![GitHub last commit](https://img.shields.io/github/last-commit/rstolpe/DeleteUserProfile?style=plastic)  
![PSGallery downloads](https://img.shields.io/powershellgallery/dt/DeleteUserProfile?style=plastic)

# DeleteUserProfile
This module will let you show all of the user profiles that are saved on a local or remote computer, you can also delete one specific user profile or all of the profiles.  
You can also return the user profiles from multiple computers at the same time.  
The special windows profiles are excluded.  
  
I have added the result from PSScriptAnalyzer in [test folder](https://github.com/rstolpe/DeleteUserProfile/tree/main/test) 

## This module will do the following
- Return all of the user profiles from a remote or local computer
- Delete one specific user profile or all of the user profiles from a local or remote computer
- Delete all user profiles from both local and remote computer
- You can exclude user profiles to show
- You can exclude user profile to be deleted
- If the user profile are loaded it will not get deleted
- The special windows profiles are excluded
  
If you use this module on a remote computer you need to make sure that you have [WinRM](https://github.com/rstolpe/Guides/blob/main/Windows/WinRM_GPO.md) activated.

# Links
* [Webpage/Blog](https://www.stolpe.io)
* [Twitter](https://twitter.com/rstolpes)
* [LinkedIn](https://www.linkedin.com/in/rstolpe/)
* [PowerShell Gallery](https://www.powershellgallery.com/profiles/rstolpe)

# Help
Below I have specified things that I think will help people with this module.  
You can also see the API for each function in the [help folder](https://github.com/rstolpe/DeleteUserProfile/tree/main/help)

## Install
Install for current user
```
Install-Module -Name DeleteUserProfile -Scope CurrentUser -Force
```
  
Install for all users
```
Install-Module -Name DeleteUserProfile -Scope AllUsers -Force
```

## Example
### Get-RSUserProfile
If you want to use this on a remote computer just add the parameter ```-ComputerName <COMPUTERNAME>``` in the commands below.  
  
```
Get-RSUserProfile
```
Return all user profiles that are saved on the local computer

```
Get-RSUserProfile -Excluded "Frank, rstolpe"
```
This will return all of the user profiles saved on the local machine except user profiles that are named Frank and rstolpe

```
Get-RSUserProfile -ComputerName "Win11-Test, Win10"
```
This will return all of the user profiles saved on the remote computers named Win11-Test and Win10

### Remove-RSUserProfile
If you want to use this on a remote computer just add the parameter ```-ComputerName <COMPUTERNAME>``` in the commands below.  
  
```
Remove-RSUserProfile -DeleteAll
```
This will delete all of the user profiles from the localhost / computer your running the module from.

```
Remove-RSUserProfile -Excluded "User1, User2" -DeleteAll
```
This will delete all of the user profiles except user profile User1 and User2 on the local computer

```
Remove-RSUserProfile -Delete "User1, User2"
```
This will delete only user profile "User1" and "User2" from the local computer where you run the script from.