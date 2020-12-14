#!/bin/bash

#ENV setup
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "$SCRIPTPATH"
##VAriables def
INITIAL_BASE="$SCRIPTPATH/histories_archive.tar.gz"
WORKDIR="$SCRIPTPATH/WORKDIR"
FRESH_BASE="$SCRIPTPATH/WORKDIR/OUAT_base_fresh"
BURNED_BASE="$SCRIPTPATH/WORKDIR/OUAT_base_burned"
IA_BASE="$SCRIPTPATH/WORKDIR/OUAT_base_IA"
VERSION="1.0.2"

#USAGE
usage () {
	#HEADER
	echo "OnceUponATime - V. $VERSION - ...OUAT"
	echo ""
	echo "(DESCRIPTION): OUAT are we takling about?"
	echo "This script is designed to (dis)play stories from $FRESH_BASE folder based on a pseudo-random logic (never the same random twice)"
	echo ""
	echo "(USAGE): OUAT is my usage?"
	echo "bash OnceUponATime.bash <button>"
	echo "<button>		def: normal mode. Stories are displayed from the story base via a pseudo-random logic."
	echo "			ia: machine learning mode. Let our IA to build you a story. (not implemented yet)"
	echo "			reset: reset/install this script WORKDIR from archive ($INITIAL_BASE)"
	echo ""
	echo "(MANPAGE): OUAT information may be necessary?"
	echo "	- This script has to be called using one argument (a.k.a <button>)"
	echo "	- The <button> argument, at version $VERSION, implements those values: {def, reset, help}"
	echo ""
	echo "(EXAMPLE) OUAT are my execution examples?"
	echo "[0] bash OnceUponIATime.bash help"
	echo "[1] bash OnceUponIATime.bash reset #RESET or INSTALL"
	echo "[2] bash OnceUponIATime.bash def #RUN ME"
	echo "[2bis] python3 -c \"import subprocess; result = subprocess.run(['bash', 'OnceUponIATime.bash', 'def'], stdout=subprocess.PIPE); print(result.stdout.decode())\" #RUN ME FROM PYTHON"
	echo ""
	echo "OUAT if i tell you GOODBYE (exit 0)"
	exit 0
}


##reset function
reset_brain() {
	echo "[I] SETTING UP $FRESH_BASE from archive ($INITIAL_BASE)"
	if [ ! -f $INITIAL_BASE ]; then
		echo "[E] $INITIAL_BASE is missing! PROJECT CORRUPTED (exit 6)"
		exit 6
	fi

	if [ -d $WORKDIR ]; then
		rm -rf $WORKDIR
	fi
	mkdir -p $WORKDIR
	mkdir -p $FRESH_BASE
	mkdir -p $BURNED_BASE
	tar zxf $INITIAL_BASE -C $FRESH_BASE --strip-components 1
}

if [ $# != 1 ]; then
	if [ ! -d $WORKDIR ]; then
		echo "[W] Install/reset required. Try running OnceUponIATime.bash reset"
	fi
	echo "[E] 1 ARGUMENT REQUIRED"
	echo ""
	usage
fi

if [ "$1" == "def" ]; then
	array=($(ls $FRESH_BASE))
	arraylen="${#array[@]}"
	if [ $arraylen -lt 1 ]; then
		echo "[E] no more stories..."
		echo "[E] PLEASE UPDATE STORY BASE!"
		echo "[I] GOODBYE..."
		exit 2
	fi

	###RANDOM HISOTRY
	history_name="${array[RANDOM%${#array[@]}]}"
	history_fullpath="$FRESH_BASE/$history_name"
	echo "----> $history_name"
	cat "$history_fullpath"

	#move history into burned base
	mv "$history_fullpath" "$BURNED_BASE/$history_name"

elif [ "$1" == "ia" ]; then
	echo "[W] function not yet implemented!!"
	echo "GOODBYE..."
	exit 3
elif [ "$1" == "reset" ]; then
	reset_brain
	exit 0
elif [ "$1" == "help" ]; then
	usage
	exit 0
else
	echo "[E] bad argument...EXITING."
	usage
	exit 5
fi
