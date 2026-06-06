@echo off
setlocal

REM One-click OpenAI Codex CLI setup for Crazyrouter on Windows.
REM Pass arguments through, for example:
REM   install-crazyrouter-codex.bat -Mode switch

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-crazyrouter-codex.ps1" %*

pause
