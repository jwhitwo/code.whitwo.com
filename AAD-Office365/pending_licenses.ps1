#connect to O365

$cred = Get-Credential #get the credential of the account to use
Connect-MsolService -Credential $cred

#retrieve all users in tenant
$all_users = Get-MsolUser -all

$pending_lic_list = ""

#iterate through each user and check if there are any pending licenses
foreach($user in $all_users)
{
    foreach($lic in $user.Licenses)
    {
        foreach($service in $lic)
        {
            foreach($sp in $service)
            {
                foreach($plan in $sp.ServiceStatus)
                {
                    if($plan.ProvisioningStatus -like 'Pending*')
                    {
                        $pending_lic_list += "$($user.UserPrincipalName),$($plan.ServicePlan.ServiceName)`r`n"
                    }
                }
            }
        }
    }
}

#output the settings to a file named pending.csv
$pending_lic_list | Out-File "pending.csv"