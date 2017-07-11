Param(
    [string]$targetdestination = 'C:\test2\tier1\tier2',
    [string]$origin = 'C:\test1\tier1\tier2'
    )
#checkDir $origin
mkdir $targetdestination # currently this only really works for directories, maybe just
#gotta figure out file structure man...   5
#could make the directory using the path name of origin to maintain file structure/hierarchy    1
cd $origin
get-childitem -rec | move-item -destination {
join-path 'C:\test2\tier1\tier2' $_.FullName.SubString($pwd.path.length) }
#no idea why but using parameter targetdestination in the join-path causes all sorts of mayhem  3
#                                    ^^^^^^
#**********for now just copy/pasta the ^^variable's value into the join-path location when need be.  4 *****************

$ShortcutFile = "$origin.lnk" 
$WScriptShell = New-Object -ComObject WScript.Shell 
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile) 
$Shortcut.TargetPath = "$targetdestination" 
$Shortcut.Save() 
cd C:\
rmdir $origin
<#^^ may have to make all the above into the else statement on a chain of ifs.
this would allow one to fix the issue of moving a lower tier and then later moving
the tiers above and still maintaining correct structure/hierarchy, if that does 
become successful will have to figure out a way to clear out shortcuts within
the lower tiers    2  #>
#maybe instead of a bunch of ifs, simply find shortcuts within, go to shortcuts' target locations and move all the stuff
# at their locations back into the directories that want to be moved, then delete shortcuts, replace them
# with their original folders and only have the one shortcut to the parent directory
# thinking recursively, 'function Check(...parentDirectory...) = foreach file in this directory check whether it is shortcut 
# or not and check whether is directory if it is directory run check(childDirectory) if shortcut then go-to shortcut
# target destination and move all items from that folder back into the original parent folder and delete shortcut'.
# may need an elseif to cover unexpected cases or to just move everything over. after running this pseudo function
# then will simply move parentDirectory over to targetdestination and make a shortcut at origin to parendtDirectory



# 7/7/2017 - 1:05
# MAY HAVE TO SEPARATE THIS, ONE FOR DIRECTORIES, ONE FOR FILES, PERHAPS ONLY MKDIR NEEDS TO BE WITHIN IF STATEMENT THO
# ACTUALLY MAYBE ALSO MOVING TO THE PARENT AND MOVING THE WHOLE DIRECTORY RATHER THAN ITS CONTENTS WOULD BE ALSO NEEDED
# WELL ON THIRD THOUGHT MAYBE JUST THE CHEDIR NEEDS TO WORRY ABOUT IT SINCE THIS IS MEANT TO MOVE CONTENTS NOT JUST SINGLE
# FOLDERS, SHORTCUTS TO INDIVIDUAL DOCUMENTS DOESN'T REALLY MAKE SENSE