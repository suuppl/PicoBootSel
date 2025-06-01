@echo off
REM """
REM Copies all contents from the local 'CIRCUITPY' folder to the 'CIRCUITPY' drive, overwriting existing files.
REM
REM :param dryrun: If set (use /dryrun), only shows what would be copied without performing the copy.
REM :raises: Error if the source folder or destination drive is not found.
REM """

setlocal

REM Parse arguments for dryrun flag
set "DRYRUN=0"
if /I "%~1"=="/dryrun" set "DRYRUN=1"

REM Set source and destination
set "SRC=%CD%\CIRCUITPY"
REM Find the drive letter for the drive named 'CIRCUITPY'
for /f "tokens=2 delims==" %%D in ('wmic logicaldisk where "VolumeName='CIRCUITPY'" get DeviceID /value 2^>nul') do set "DST=%%D\"

REM Check if source exists
if not exist "%SRC%\" (
    echo Source folder '%SRC%' does not exist.
    exit /b 1
)

REM Check if destination drive exists
if not exist "%DST%" (
    echo Destination drive '%DST%' not found.
    exit /b 1
)

if "%DRYRUN%"=="1" (
    echo [DRYRUN] Would copy from "%SRC%\" to "%DST%\"
    echo [DRYRUN] Files and folders to be copied:
    echo "%SRC%\*" "%DST%\" /E /H /L /C /Q
    echo [DRYRUN] No files were actually copied.
) else (
    REM Copy all files and folders, overwrite everything
    REM Delete all existing files and folders on the destination drive
    echo Deleting all contents from "%DST%\"...
    del /F /Q "%DST%\*" >nul 2>&1
    for /D %%F in ("%DST%\*") do rd /S /Q "%%F" >nul 2>&1
    xcopy "%SRC%\*" "%DST%\" /E /H /Y /C /Q

    if errorlevel 1 (
        echo Copy operation completed with errors.
    ) else (
        echo Copy operation completed successfully.
    )
)

endlocal