REM startup-skript til windows. lag en symlink i denne mappa: C:\Users\nikol\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup ved å kjøre denne kommandoen som admin i cmd: 
REM > mklink startup.bat C:\work\dotfiles\startup.bat

@echo off
subst w: c:\work
