<#test some stuff
Param(
    [string]$Spaghetti
)
Write-Output "YOU CANNOT HANDLE THE $Spaghetti" 
Param(
    [string]$currentplace='C:\test1\'
)
$files = Get-ChildItem $currentplace
foreach-object{
    $attempt = (get-item $file).PSIsContainer
    if ($attempt -eq 'true'){
        Write-Output "$file is a Directory"
    }
    elseif ($file.EndsWith('.lnk')){
        Write-Output "$file is a Shortcut"
    } 

}

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
}
<#function potato($scriptpath){
    $lnkFiles = Get-ChildItem -Path $scriptPath -Recurse -Include *.lnk
    foreach-object in $lnkFiles{
        
        Write-Output "$_ <- this"
    }
}
#Write-Output "$lnkFiles are shortcuts"
}
Param(
    [string]$scriptPath='C:\test1\'
)
$lnkFiles = Get-ChildItem -Path $scriptPath -Recurse -Include *.lnk
Write-Output "$lnkFiles"
foreach($item in $lnkFiles){
    mkdir ("$item" + '1')
    cd "$item" 
    #Write-Output '$scriptPath''$item''1'
    $sh = new-object -com wscript.shell
    $tpath = $sh.CreateShortcut($item).TargetPath
    #Write-output "The target path of this shortcut is: $tPath"
    C:\ezPS1\movefiles.ps1 $tPath ("$item" + '1')
    #Write-Output "$item is a shortcut"
    del $item
    
}

#need to have the foreach make a directory at the origin and then move the files into that directory then 
#delete shortcut last, need to think about going sort out directories as well, then add to checkdir

#so i guess the lnkfiles finds all shortcuts within directory, so no need for recursively calling 
#the function for each new child directory, this could make this easier....or harder...
Param([string]$origin = 'C:\test2\tier1', [string]$endpoint = 'tier2')
mkdir "$origin\$endpoint"
Write-Output "I always ride the $origin\$endpoint path on my way home!"
Get-ChildItem -path C:\test2 -recurse | Where {$_.PSIsContainer -and `
@(Get-ChildItem -Lit $_.Fullname -r | Where {!$_.PSIsContainer}).Length -eq 0} |
Remove-Item -recurse 
#[io.path]::GetFileNameWithoutExtension("c:\test1\confusion.txt") #confusion

#Write-Output '$withoutExt'
Add-Type -AssemblyName System.Windows.Forms
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
[void]$FolderBrowser.ShowDialog()
$FolderBrowser.SelectedPath>
function Find-Folders {
    [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    [System.Windows.Forms.Application]::EnableVisualStyles()
    $browse = New-Object System.Windows.Forms.FolderBrowserDialog
    $browse.SelectedPath = "C:\"
    $browse.ShowNewFolderButton = $false
    $browse.Description = "Select a directory"

    $loop = $true
    while($loop)
    {
        if ($browse.ShowDialog() -eq "OK")
        {
        $loop = $false
		
		#Insert your script here
		
        } else
        {
            $res = [System.Windows.Forms.MessageBox]::Show("You clicked Cancel. Would you like to try again or exit?", "Select a location", [System.Windows.Forms.MessageBoxButtons]::RetryCancel)
            if($res -eq "Cancel")
            {
                #Ends script
                return
            }
        }
    }
    $browse.SelectedPath
    $browse.Dispose()
} 
Find-Folders#>
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
Write-Output $origin