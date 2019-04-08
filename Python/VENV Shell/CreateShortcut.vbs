Dim WshShell, strCurDir, venvShortcut

Set WshShell = WScript.CreateObject("WScript.Shell")
strCurDir = WshShell.CurrentDirectory

Set venvShortcut = WshShell.CreateShortcut(strCurDir&"\VENV Shell.lnk")
venvShortcut.IconLocation = strCurDir&"\icon\pearl_98384.ico"
venvShortcut.TargetPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
venvShortcut.Arguments = "-NoLogo -NoExit -File """&strCurDir&"\VENVShell.ps1"""
venvShortcut.WorkingDirectory = "C:\"
venvShortcut.Save

Set venvShortcut = Nothing
Set WshShell = Nothing