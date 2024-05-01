$profilelist = "HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"
$loggedonuser = Get-Ciminstance -ClassName Win32_ComputerSystem | Select-Object UserName
$loggedonusername = $loggedonuser.username
$userwithoutdomain = $loggedonusername -replace "^.*?\\"
$GetSID = Get-ChildItem -Path $profilelist -rec -ea SilentlyContinue | % { if((get-itemproperty -Path $_.PsPath) -match "$userwithoutdomain") { $_.PsPath} }
$SID = $GetSID -replace "^.*?list\\"
#Thanks to Gannon Novak at smbtothecloud.com for the above solution
#====================================================#

#Remove any identically named drives
Remove-PSDrive -Name HKU

#Create a drive to find the registry paths in
New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS

#Define registry paths as variables to reference later, an example
$RegPath8 = "HKU:\$SID\Control Panel\Cursors"

#If the value of this registry entry contains the defined value, exit with code 0. If not, exit with code 1.
$ArrowValue = Get-ItemPropertyValue $RegPath8 -Name Arrow
If ($ArrowValue.Contains('aero_arrow.cur')) {
    Write-Output "Detected"
    Exit 0
}
Else {
    Write-Output "Not Detected"
    exit 1
}
