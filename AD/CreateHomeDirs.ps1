# File: 		CreateHomeDirs.ps1
# Created By: 	Jeff Whitworth
# Date: 		1/6/2011
#
# Description:	Create a directory for every user with the SamAccountName the directory name.
#              	Set the permissions so the user has read, write and modify.
#
# Usage: 		Run CreateHomeDirs.ps1 in the directory where the directories will be created.
#				Note: Any existing directories will be skipped, but ACLs will be applied

$time = Get-Date
Write-Host("Start time: $($time.ToShortTimeString())")

Write-Host("Reading users...")
#Get all AD Users :: Modify to suit your needs
$users = Get-ADUser -Filter *
Write-Host("$($users.Count) users found!")

#Create a directory and set the ACL
Write-Host("Creating directories...")
foreach($user in $users)
{
	$path = $user.SamAccountName
	$dir = New-Item -Path $path -ItemType Directory
}
Write-Host("done! Setting ACLs...")

#Set ACLs for each directory
foreach($user in $users)
{
	$acl = Get-Acl $user.SamAccountName
	#change to desired permissions
	$perm = $user.SamAccountName,"Modify","ContainerInherit,ObjectInherit","None","Allow"
	$ar = New-Object System.Security.AccessControl.FileSystemAccessRule $perm
	$acl.SetAccessRule($ar)
	$acl | Set-Acl $user.SamAccountName
}
Write-Host("Done!")

$time = Get-Date
Write-Host("End time: $($time.ToShortTimeString())")