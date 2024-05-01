# Powershell Registry Edits
Putting Powershell scripts into ``.intunewin`` packages is an incredibly effective way to upload and run them on an endpoint. The scripts in this repository contain a solution to a critical issue in getting them to apply registry changes under HKCU, which I then utilize for building out configurations.

This is primarily to showcase the effectiveness of this tool, and a case in which I applied it.

## What is this?
Thanks to [Gannon Novak at smbtothecloud](https://smbtothecloud.com/powershell-intune-to-edit-hkcu-registry-as-system-when-standard-users-dont-have-permission/), the scripts dynamically grab the SID of the currently logged on user so that their specific registry hive can be viewed or edited. Novak's article describes this issue in greater detail, but in essence, running a Powershell script after it's downloaded onto an endpoint in Intune will only run it as the ``SYSTEM`` user. This becomes a problem when wanting to write to a user-specific hive in the registry, like ``HKEY_CURRENT_USER``

Using his method of dynamically grabbing the correct SID opens up vast opportunities for making registry changes on endpoints. In the example included in this repository, I show some preference changes that I wrote out and deployed for users.

## What are the most important things to know?
Registry paths and the desired values to be changed must be defined manually. An example being as follows:

``$RegPath8 = "HKU:\$SID\Control Panel\Cursors"``

This line assigns a registry path to a variable, using the earlier $SID variable that was dynamically written to complete it. Next, this following line uses that registry path to change a value in the desired key:

``New-ItemProperty -Path $RegPath8 -Name AppStarting -Value "%SystemRoot%\cursors\arrow_rl.cur" -PropertyType ExpandString -Force | Out-Null``

With those two pieces of knowledge, this script can be easily modified (as I have done for multiple Intune configurations) to add, edit, or delete registry entries. Importantly, it's easily modified to create detection and uninstallation scripts as well. I have included an example detection script [here](HKCU-RegistryChanges-Detection.ps1).

#### I have included comments in the scripts to describe the important actions that they are doing.

## What do these examples do?

#### <ins>[HKCU-RegistryChanges.ps1](HKCU-RegistryChanges.ps1)</ins>

Upon deploying a configuration to several internal facing kiosk-styled setups, I had some users complain about their difficulty in seeing the white mouse cursor on the white background of a website.

I researched what registry key control the mouse cursor settings. I set the mouse cursor settings through the GUI on my own machine to the Windows "Large Black" profile, and then took note of what the registry values were set to in ``HKEY_CURRENT_USER\Control Panel\Cursors``. I then added lines into the script to set those values.

#### <ins>[HKCU-RegistryChanges-Detection.ps1](HKCU-RegistryChanges-Detection.ps1)</ins>

To detect that these changes have been made, I use a simple if statement. I assign the value of the registry entry to a variable, and then look for key content in that value as such:

~~~
$ArrowValue = Get-ItemPropertyValue $RegPath8 -Name Arrow

If ($ArrowValue.Contains('aero_arrow.cur')) {
    Write-Output "Detected"
    Exit 0
}
Else {
    Write-Output "Not Detected"
    exit 1
}
~~~