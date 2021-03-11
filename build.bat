@ECHO OFF

SETLOCAL EnableDelayedExpansion

set SCONSFLAGS=-j%NUMBER_OF_PROCESSORS%

IF "%~1" == "" GOTO :eof

IF "%~1" == "glue" GOTO %~1
IF "%~1" == "editor" GOTO %~1
IF "%~1" == "fulleditor" GOTO %~1
IF "%~1" == "debug" GOTO %~1
IF "%~1" == "release" GOTO %~1
IF "%~1" == "fulldebug" GOTO %~1
IF "%~1" == "fullrelease" GOTO %~1



:glue
    CALL scons profile=temp_profile.py

    IF ERRORLEVEL 0 bin\godot.windows.tools.64.mono --generate-mono-glue modules/mono/glue
    
    IF ERRORLEVEL 0 IF NOT "%~1" == "glue" GOTO %~1
    
GOTO :eof


:editor
    CALL scons profile=editor_profile.py

    SET dirs[0]="Authentication Server Editor\"
    SET dirs[1]="Gateway Server Editor\"
    SET dirs[2]="Game Server Editor\"
    SET dirs[3]="Client Editor\"

    CD bin\

    FOR /L %%i IN (0,1,3) DO (
        IF NOT EXIST !dirs[%%i]! MKDIR !dirs[%%i]!
        XCOPY /Y "godot.windows.opt.tools.64.mono.exe" !dirs[%%i]! >NUL
        XCOPY /S /E /Y "GodotSharp" !dirs[%%i]!GodotSharp\ >NUL
        XCOPY /Y "mono-2.0-sgen.dll" !dirs[%%i]!\ >NUL
        IF NOT EXIST "!dirs[%%i]!._sc_" TYPE NUL>"!dirs[%%i]!._sc_"
    )

    cd ..
GOTO :eof


:fulleditor    
    CALL :glue editor

GOTO :eof


:debug
    CALL scons profile=debug_profile.py

GOTO :eof


:fulldebug
    CALL :glue debug

GOTO :eof


:release
    CALL scons profile=release_profile.py

GOTO :eof


:fullrelease
    CALL :glue release

GOTO :eof
