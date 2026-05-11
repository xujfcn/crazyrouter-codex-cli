@echo off
setlocal

REM One-click switch OpenAI Codex CLI to Crazyrouter on Windows.
REM This wrapper runs the PowerShell installer in this repository.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-crazyrouter-codex.ps1"

pause
