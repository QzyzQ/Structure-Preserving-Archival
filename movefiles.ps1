<#moves all files from (change cd link)test1 to test2, doesn't make shortcuts, may have issues with file structure, 
doesn't really allow specific files to be archived, just mass archival
need a way to dynamicall create shortcuts but at the same time not move the shortcuts 
from test1. possible to just allow move and then move all .lnk files back to test1, that could work although
file structure may have issues with that.#>
Param(
    [string]$from = $args[0],
    [string]$to = $args[1]
    )
Get-ChildItem -path $from -Recurse | Move-Item -Destination $to