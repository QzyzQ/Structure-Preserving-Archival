$ShortcutFile = "C:\test1\tier1\tier2\tier3\Archives.lnk" 
$WScriptShell = New-Object -ComObject WScript.Shell 
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile) 
$Shortcut.TargetPath = "C:\Archives" 
$Shortcut.Save() 
#C:\test1\tier1\tier2\tier3\Archives.lnk
#C:\Archives
#C:\test1\tier1\tier2.lnk
#C:\test2\tier1\tier2