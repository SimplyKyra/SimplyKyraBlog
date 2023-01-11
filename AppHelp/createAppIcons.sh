#!/bin/bash

# Run as: ./createAppIcons.sh
# Assumes you are running the script where you want it to execute.
# Confirm the proper argument was given; otherwise a blank argument would send you to the home directory
if [ $# -ne 1 ]; then
    echo "Please call this script with one argument - the image file you want to resize."
    exit 1
elif [ ! -e "$PWD" ]; then
    echo "Directory doesn't exist. Please pass in a valid directory you want the program to run in for the first argument." 
    exit 1
elif [ ! -d "$PWD" ]; then
    echo "That isn't a directory. Please pass in a valid directory for the program to run in."
    exit 1 
fi

echo -e "\nWorking in directory: $PWD\nWorking on file: $1\n"

# Checks to see the condition returned and if failed exits he program
if [ ! -f "$1" ]; then
    echo "Couldn't access the file specified. Exiting."
    exit 1
fi

echo "Checking dimensions of image: $1"
width=$(identify -format '%w' "$1" )
height=$(identify -format '%h' "$1")

if [ $width -ne $height ]; then
    echo "Image is not a square! It's height is $height and width is $width."
    echo "Exiting program. Please fix and run this again."
    exit 1
fi    

echo "Image is a square so about to run the script on file: $1"

magick "$1" -resize 1024x1024 "1024 - $1"
magick "$1" -resize 512x512 "512 - $1"
magick "$1" -resize 256x256 "256 - $1"
magick "$1" -resize 128x128 "128 - $1"
magick "$1" -resize 64x64 "64 - $1"
magick "$1" -resize 32x32 "32 - $1"
magick "$1" -resize 16x16 "16 - $1"
