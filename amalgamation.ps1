﻿<#remove-item alias:cd -force
function cd($target)
{
    if($target.EndsWith(".lnk"))
    {
        $sh = new-object -com wscript.shell
        $fullpath = resolve-path $target
        $targetpath = $sh.CreateShortcut($fullpath).TargetPath
        set-location $targetpath
    }
    else {
        set-location $target
    }
}could be setup in user profile for Powershell but I figured this would allow for easier transporting the script#>
$origin = Read-host "Please enter the directory that contains the folder that is being moved. Please include path, 
for example 'C:\Users\your.name\Desktop\Prod'"

$youngestChildDir = Read-host "Please enter the name of the folder that you wish to move, for example 'prod'"

$targetdestination = Read-host "Please enter the directory that you wish to move items TO. Please include path,
for example 'C:\Archives'"
Write-Output "$origin is the directory of the folder to be moved"
Write-Output "$targetdestination is the destination that the folder will be moved to"
Write-Output "$youngestChildDir is the folder to be moved"
$lnkFiles = Get-ChildItem -Path "$origin" -Recurse -Include *.lnk
#cd $origin
foreach($item in $lnkFiles){
    mkdir ("$item" + '1')
    cd "$item"    
    $sh = new-object -com wscript.shell
    $tpath = $sh.CreateShortcut($item).TargetPath    
    Get-ChildItem -path $tPath -Recurse | Move-Item -Destination ("$item" + '1')   
    del $item
    #need to also delete the directory that is left behind where the shortcut was pointed at
     #****************** DOESN'T WORK IF SHORTCUT EXISTS THAT IS HIGHER ORDER THAN DESIRED DIRECTORY **********
}    #Above is what searches for shortcuts and moves the contents of the shortcuts' target back into the
     #shortcut's original directory and then deletes the shortcut
    
    #below creates a directory in the new location and then moves all the files within the current location into it

mkdir "$targetdestination\$youngestChildDir" # currently this only really works for directories, which should be enougbh
Write-Output "I always ride the $targetdestination\$youngestChildDir path on my way home!"
cd $origin

Get-ChildItem -path "$origin\$youngestChildDir" -Recurse | Move-Item -Destination "$targetdestination\$youngestChildDir"
#
$ShortcutFile = "$origin\$youngestChildDir.lnk" 
$WScriptShell = New-Object -ComObject WScript.Shell 
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile) 
$Shortcut.TargetPath = "$targetdestination\$youngestChildDir" 
$Shortcut.Save() 
cd C:\
rmdir "$origin\$youngestChildDir"

# below should recursively remove empty folders from target directory
Get-ChildItem -path $targetdestination -recurse | Where {$_.PSIsContainer -and `
@(Get-ChildItem -Lit $_.Fullname -r | Where {!$_.PSIsContainer}).Length -eq 0} |
Remove-Item -recurse
#
#rename the .lnk1 directories
