@ECHO OFF


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
    CMD /C "scons profile=temp_profile.py mono_glue=no"

    CMD /C "bin\godot.windows.tools.64.mono --generate-mono-glue modules/mono/glue"
    
    IF NOT "%~1" == "glue" GOTO %~1
    
GOTO :eof


:editor
    CALL scons profile=editor_profile.py

    IF NOT EXIST "bin\._sc_" TYPE NUL> "bin\._sc_"
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
