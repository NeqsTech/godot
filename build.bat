@echo off

IF "%~1" == ""  GOTO eof
IF "%1" == "temp" GOTO temp
IF "%1" == "glue" GOTO glue
IF "%1" == "editor" GOTO editor
IF "%1" == "export" GOTO export
IF "%1" == "fulleditor" GOTO fulleditor

:temp
scons p=windows tools=yes module_mono_enabled=yes mono_glue=no -j%NUMBER_OF_PROCESSORS%
GOTO EOF

:glue
bin\godot.windows.tools.64.mono --generate-mono-glue modules/mono/glue
GOTO EOF

:editor
scons p=windows target=release_debug tools=yes module_mono_enabled=yes -j%NUMBER_OF_PROCESSORS%
GOTO EOF

:export
IF "%~2" == "" GOTO debug
IF "%2" == "debug" GOTO debug
IF "%2" == "d" GODO debug
IF "%2" == "release" GOTO release
IF "%2" == "r" GOTO release

:fulleditor
cmd /c "scons p=windows tools=yes module_mono_enabled=yes mono_glue=no -j%NUMBER_OF_PROCESSORS%"

cmd /c "bin\godot.windows.tools.64.mono --generate-mono-glue modules/mono/glue"

cmd /c "scons p=windows target=release_debug tools=yes module_mono_enabled=yes -j%NUMBER_OF_PROCESSORS%"
GOTO EOF

:EOF
