if test "$#" -ne 3; then
    echo "Syntax: ./create_hfs_disk.sh [input_file] [output_file] [size_in_1k]"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "Input file not found!"
    exit 1
fi

dd if=/dev/zero of=$2 bs=1024 count=$3
hformat -l "Test Apps" "$2"
hmount "$2"
filename=$(basename "$1")
filename2="${filename%.*}"
hcopy "$1" ":$filename2"
humount "$2"
