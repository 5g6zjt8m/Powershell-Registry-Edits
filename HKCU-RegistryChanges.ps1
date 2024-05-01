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

#If the registry paths do not exist, create them.
If (-NOT (Test-Path $RegPath8)) {
  New-Item -Path $RegPath8 -Force | Out-Null
} 

#Sets all of the cursor icons to Windows "Large Black" for better contrast
New-ItemProperty -Path $RegPath8 -Name AppStarting -Value "%SystemRoot%\cursors\arrow_rl.cur" -PropertyType ExpandString -Force | Out-Null
New-ItemProperty -Path $RegPath8 -Name Arrow -Value "%SystemRoot%\cursors\arrow_rl.cur" -PropertyType ExpandString -Force | Out-Null
New-ItemProperty -Path $RegPath8 -Name ContactVisualization -Value "1" -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $RegPath8 -Name Crosshair -Value "%SystemRoot%\cursors\cross_rl.cur" -PropertyType ExpandString -Force | Out-Null
New-ItemProperty -Path $RegPath8 -Name CursorBaseSize -Value "32" -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $RegPath8 -Name Hand -Value "%SYSTEMROOT%\Cursors\arrow_rl.cur" -PropertyType ExpandString -Force | Out-Null
New-ItemProperty -Path $RegPath8 -Name Help -Value "%SystemRoot%\cursors\help_rl.cur" -PropertyType ExpandString -Force | Out-Null
New-ItemProperty -Path $RegPath8 -Name IBeam -Value "%SystemRoot%\cursors\beam_rl.cur" -PropertyType ExpandString -Force | Out-Null
New-ItemProperty -Path $RegPath8 -Name No -Value "%SystemRoot%\cursors\no_rl.cur" -PropertyType ExpandString -Force | Out-Null
New-ItemProperty -Path $RegPath8 -Name NWPen -Value "%SystemRoot%\cursors\pen_rl.cur" -PropertyType ExpandString -Force | Out-Null
New-ItemProperty -Path $RegPath8 -Name "Scheme Source" -Value "2" -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $RegPath8 -Name SizeAll -Value "%SystemRoot%\cursors\move_rl.cur" -PropertyType ExpandString -Force | Out-Null
New-ItemProperty -Path $RegPath8 -Name SizeNESW -Value "%SystemRoot%\cursors\size1_rl.cur" -PropertyType ExpandString -Force | Out-Null
New-ItemProperty -Path $RegPath8 -Name SizeNS -Value "%SystemRoot%\cursors\size4_rl.cur" -PropertyType ExpandString -Force | Out-Null
New-ItemProperty -Path $RegPath8 -Name SizeNWSE -Value "%SystemRoot%\cursors\size2_rl.cur" -PropertyType ExpandString -Force | Out-Null
New-ItemProperty -Path $RegPath8 -Name SizeWE -Value "%SystemRoot%\cursors\size3_rl.cur" -PropertyType ExpandString -Force | Out-Null
New-ItemProperty -Path $RegPath8 -Name UpArrow -Value "%SystemRoot%\cursors\up_rl.cur" -PropertyType ExpandString -Force | Out-Null
New-ItemProperty -Path $RegPath8 -Name Wait -Value "%SystemRoot%\cursors\busy_rl.cur" -PropertyType ExpandString -Force | Out-Null
New-ItemProperty -Path $RegPath8 -Name "(Default)" -Value "Windows Black (extra large)" -PropertyType String -Force | Out-Null
New-ItemProperty -Path $RegPath8 -Name Pin -Value "%SystemRoot%\cursors\pin_rl.cur" -PropertyType ExpandString -Force | Out-Null
New-ItemProperty -Path $RegPath8 -Name Person -Value "%SystemRoot%\cursors\person_rl.cur" -PropertyType ExpandString -Force | Out-Null

#Remove the temporarily mounted drive
Remove-PSDrive -Name HKU
