clear;

EMFOLDER="$HOME/pce-mac-classic"

if [ $# -ne 3 ] ; then
    echo 'Syntax: ./build_and_run.sh [project_name]'
    exit 1
fi

if [ ! -d "$1" ]; then
    echo 'The specified project folder does not exist'
    exit 1
fi

PRNAME=${1%/}

rm -rf "$PRNAME/build"
./build.sh "$PRNAME"

OUTFILE="$PRNAME/build/$PRNAME.bin"
IMGFILE=sample_apps.img
IMGSIZE=8000

if [ -f $OUTFILE ]; then
   cp "$OUTFILE" "$EMFOLDER"

   rm -rf $IMGFILE
   ./create_hfs_disk.sh "$OUTFILE" $IMGFILE $IMGSIZE

   mv $IMGFILE "$EMFOLDER/$IMGFILE"
   cd "$EMFOLDER"
   pkill -9 -e -f pce-macplus
   sh run.sh

   rm -rf $OUTFILE
   rm -rf "$EMFOLDER/$PRNAME.bin"
else
    echo "Build failed: $OUTFILE not found!"
    exit 1
fi
