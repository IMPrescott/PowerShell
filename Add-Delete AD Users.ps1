# Active Directory
Import-Module ActiveDirectory

cls
" "
" "

do
 {
    $selection = Read-Host "Please make a selection [D]elete User, [A]dd User, [L]ist Users, [Q]uit"
    switch ($selection)
    {
    'D' {
    " "
    "**Delete an Active Directory User**"
    Write-Host -ForegroundColor Yellow "**Enter a User's samAccountName to Delete them**"
    " "
    $Username = Read-Host "Enter Logon Name"

    if ( $Username )
    {
        Remove-ADUser -Identity $Username -Confirm:$false
        " "
        Write-Host -BackgroundColor DarkGreen "$Username has been removed from Active Directory!"
    }
    } 
    'A' {
    
    " "
    "Add an Active Directory User"
    " "

    # Arrays for the script
    $FirstName = Read-Host "Enter First Name"
    $Surname = Read-Host "Enter Last Name"
    $Username = $FirstName.Substring(0,1) + $Surname
    #$Username = Read-Host "Enter Logon Name (i.e - FirstinitialLastName)"
    $ADgroups = Read-Host "What Group do you want to add this user to?"
    #$Password = Read-Host "Enter a Password" | ConvertTo-SecureString -AsPlainText -Force

    # Creating Displayname, First name, surname, samaccountname, UPN, etc and entering and a password for the user.
    New-ADUser `
    -Name "$FirstName $Surname" `
    -GivenName $FirstName `
    -Surname $Surname `
    -SamAccountName $Username `
    -UserPrincipalName $Username@adatum.com `
    -Displayname "$FirstName $Surname" `
    -Path "CN=Users,DC=adatum,DC=com" `
    #-AccountPassword $Password

    # Set required details
    Set-ADUser $Username -PasswordNotRequired $True
    Set-ADUser $Username -Enabled $True
    Set-ADUser $Username -ChangePasswordAtLogon $True 
    Set-ADUser $Username -EmailAddress "$Username@adatum.com"
    
    # Sets Group membership, only if one was entered
    if ( $ADgroups )
    {
        Add-ADGroupMember -Identity $ADgroups -Members $Username
    }

    # Displays confirmation that the operation was completed successfully
    " "
    Write-Host -BackgroundColor DarkGreen "Active Directory $Username account setup complete!"
    if ( $ADgroups )
    {
        Write-Host -BackgroundColor DarkGreen "Also, $Username was assigned to the $ADgroups group!"
    }
    }
    'L' {
        cls
        " "
        "**List Users**"
        " "
        Get-ADUser -Filter * -Properties * | Select Name, SamAccountName, UserPrincipalName 
    }
    }
    " "
 }
until ($selection -eq 'Q')
