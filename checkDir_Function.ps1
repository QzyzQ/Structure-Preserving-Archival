remove-item alias:cd -force
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
}#could be setup in user profile for Powershell but I figured this would allow for easier transporting the script

function checkDir([string]$arg1) \{
 # this may be necessary, idk|||dir $desiredDir |||not sure how to select only .lnk and childDirectories, but for now just assume i've found which are i guess
 #---placeholder for file identification--- will use pseudo code fr now until i understand powershell better
 if  ($file.EndsWith('.lnk'){
    cd $file #should follow shortcut due to redefined cd at beginning of script|
    C:\ezPS1\movefiles.ps1 <#arg0==CURRENTDIRECTORY#> $arg1|
    cd $arg1 |#could move this to the movefiles.ps1 to clean up
    del '$file.lnk'
 } 
 elseif (<#$file == childDirectory#>){
    checkDir childDirectory
 }

\}
<#maybe instead of a bunch of ifs, simply find shortcuts within, go to shortcuts' target locations and move all the stuff
 at their locations back into the directories that want to be moved, then delete shortcuts, replace them
 with their original folders and only have the one shortcut to the parent directory
 thinking recursively, 'function Check(...parentDirectory...) = foreach file in this directory check whether it is shortcut 
 or not and check whether is directory if it is directory run check(childDirectory) if shortcut then go-to shortcut
 target destination and move all items from that folder back into the original parent folder and delete shortcut'.
 may need an elseif to cover unexpected cases or to just move everything over. after running this pseudo function
 then will simply move parentDirectory over to targetdestination and make a shortcut at origin to parendtDirectory
 Full line 5 option:
 
 foreach ($file in $arg1) get-item $file -is [System.IO.DirectoryInfo] 
 if true checkDir $file 
 elseif false && $file.EndsWith('.lnk')

$sh = New-Object -COM WScript.Shell
cd $sh.CreateShortcut('your-files-here.lnk').TargetPath

 Possibility for following shortcut:

remove-item alias:cd -force
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
https://superuser.com/questions/393279/how-can-i-follow-a-windows-shortcut-in-power-shell
#>