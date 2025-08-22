@echo off
setlocal

set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"

set "LABELME_PATH=%ROOT%\labelme"

for /f "usebackq delims=" %%i in (`python -c "import os, osam; print(os.path.dirname(osam.__file__))"`) do set "OSAM_PATH=%%i"

if exist "%ROOT%\build\Labelme.spec" del /f /q "%ROOT%\build\Labelme.spec"
if exist "%ROOT%\build" rd /s /q "%ROOT%\build"
if exist "%ROOT%\dist" rd /s /q "%ROOT%\dist"

set "SPEC_DIR=%ROOT%\build"
set "WORK_DIR=%ROOT%\build\work"
set "DIST_DIR=%ROOT%\dist"

pyinstaller "%LABELME_PATH%\__main__.py" ^
    --name=Labelme ^
    --windowed ^
    --noconfirm ^
    --specpath="%SPEC_DIR%" ^
    --workpath="%WORK_DIR%" ^
    --distpath="%DIST_DIR%" ^
    --add-data="%OSAM_PATH%\_models\yoloworld\clip\bpe_simple_vocab_16e6.txt.gz;osam\_models\yoloworld\clip" ^
    --add-data="%LABELME_PATH%\config\default_config.yaml;labelme\config" ^
    --add-data="%LABELME_PATH%\icons\*;labelme\icons" ^
    --add-data="%LABELME_PATH%\translate\*;translate" ^
    --icon="%LABELME_PATH%\icons\icon.png" ^
    --onedir

echo.
echo Build finished. Output: "%DIST_DIR%\Labelme"
echo.
endlocal
pause