<#remove-item alias:cd -force
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
    }the above is the altering of the 'cd' alias so that it can be used on a shortcut to go to the shortcut's target
}could be setup in user profile for Powershell but I figured this would allow for easier transporting the script#>
function DangerousArchive{
[cmdletbinding(SupportsShouldProcess=$True)]
Param( 
)
#above allows whatif to be used for this script, below is the user-input parameters
Add-Type -AssemblyName System.Windows.Forms
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$FolderBrowser.Description = 'First select the directory that contains the folder you desire to move'
$result = $FolderBrowser.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true }))
if ($result -eq [Windows.Forms.DialogResult]::OK){
    $FolderBrowser.SelectedPath
    $origin = $FolderBrowser.SelectedPath
    
}
else {
    exit
}
$youngestChildDir = Read-host "Please enter the name of the folder that you wish to move, for example 'prod'"
Add-Type -AssemblyName System.Windows.Forms
$FolderBrowserZ = New-Object System.Windows.Forms.FolderBrowserDialog
$FolderBrowserZ.Description = 'Finally, choose the location you want to move the folder to'
$result = $FolderBrowserZ.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true }))
if ($result -eq [Windows.Forms.DialogResult]::OK){
    $FolderBrowserZ.SelectedPath
    $targetdestination = $FolderBrowserZ.SelectedPath
    
}
else {
    exit
}


$lnkFiles = Get-ChildItem -Path "$origin\$youngestChildDir" -Recurse -Include *.lnk

if ($lnkFiles.length -gt 0){ 
    foreach($item in $lnkFiles){
        $fileNoExt = "$item".Substring(0, "$item".LastIndexOf('.'))
        mkdir "$fileNoExt"
        cd "$item"    
        $sh = new-object -com wscript.shell
        $tpath = $sh.CreateShortcut($item).TargetPath    
        Get-ChildItem -path $tPath -Recurse | Move-Item -Destination "$fileNoExt"   
        del $item

    }    #Above is what searches for shortcuts and moves the contents of the shortcuts' target back into the
}      #shortcut's original directory and then deletes the shortcut
    
    #below creates a directory in the new location and then moves all the files within the current location into it

mkdir "$targetdestination\$youngestChildDir" 
cd $origin

Get-ChildItem -path "$origin\$youngestChildDir" -Recurse | Move-Item -Destination "$targetdestination\$youngestChildDir"
$ShortcutFile = "$origin\$youngestChildDir.lnk" 
$WScriptShell = New-Object -ComObject WScript.Shell 
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile) 
$Shortcut.TargetPath = "$targetdestination\$youngestChildDir" 
$Shortcut.Save() 
cd C:\
Write-Output "$targetdestination\$youngestChildDir should be the destination of the shortcut"
rmdir "$origin\$youngestChildDir"

# below should recursively remove empty folders from target directory
Get-ChildItem -path $targetdestination -recurse | Where {$_.PSIsContainer -and `
@(Get-ChildItem -Lit $_.Fullname -r | Where {!$_.PSIsContainer}).Length -eq 0} |
Remove-Item -recurse

}
