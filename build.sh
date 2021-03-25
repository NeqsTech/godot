#!/bin/bash

export SCONSFLAGS="-j$(grep -c ^processor /proc/cpuinfo)"

main() {
	if [ -z "$1" ]; then
		exit -1
	elif [ "$1" = glue ]; then
		glue
	elif [ "$1" = serverglue ]; then
		serverglue
	elif [ "$1" = headless ]; then
		headless
	elif [ "$1" = fullheadless ]; then
		fullheadless
	elif [ "$1" = server ]; then
		server
	elif [ "$1" = fullserver ]; then
		fullserver
	elif [ "$1" = release ]; then
		release
	elif [ "$1" = fullrelease ]; then
		fullrelease
	fi
}

headless() {
	scons p=server target=release_debug tools=yes module_mono_enabled=yes warnings=no use_llvm=yes CCFLAGS="-mtune=cortex-a72 -mcpu=cortex-a72 -mfloat-abi=hard -mlittle-endian -munaligned-access -mfpu=neon-fp-armv8"
}

fullheadless() {
	serverglue "headless"
}

server() {
	scons p=server target=release tools=no module_mono_enabled=yes warnings=no use_llvm=yes CCFLAGS="-mtune=cortex-a72 -mcpu=cortex-a72 -mfloat-abi=hard -mlittle-endian -munaligned-access -mfpu=neon-fp-armv8"
}

fullserver() {
	serverglue "server"
}

release() {
	scons p=server target=release tools=no module_mono_enabled=yes warnings=no use_llvm=yes CCFLAGS="-mtune=cortex-a72 -mcpu=cortex-a72 -mfloat-abi=hard -mlittle-endian -munaligned-access -mfpu=neon-fp-armv8"
}

fullrelease() {
	glue "release"
}

glue() {
	scons p=x11 tools=yes module_mono_enabled=yes mono_glue=no warnings=no use_llvm=yes CCFLAGS="-mtune=cortex-a72 -mcpu=cortex-a72 -mfloat-abi=hard -mlittle-endian -munaligned-access -mfpu=neon-fp-armv8"

	bin/godot.x11.tools.32.llvm.mono --generate-mono-glue modules/mono/glue

	if [ -z "$1" ]; then
		exit -2
	else
		f=$1
		$f
	fi
}

serverglue() {
	scons p=server tools=yes module_mono_enabled=yes mono_glue=no warnings=no use_llvm=yes CCFLAGS="-mtune=cortex-a72 -mcpu=cortex-a72 -mfloat-abi=hard -mlittle-endian -munaligned-access -mfpu=neon-fp-armv8"

	bin/godot_server.x11.tools.32.llvm.mono --generate-mono-glue modules/mono/glue

	if [ -z "$1" ]; then
		exit -2
	else
		f=$1
		$f
	fi
}

main "$@"; exit 0
