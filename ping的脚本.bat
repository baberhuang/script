@echo off
Set a=172.16.97.71
ping %a%
if ERRORLEVEL 1 (echo %a% unreachable) else (echo %a% reachable)
pause