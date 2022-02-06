#!/bin/bash

# Example execution:
# ./compress_and_watermark_image_with_arguments.sh pathway/to/directory/with/images/to/execute/on watermark.png
# Needs two arguments:
#   1. Pathway to directory where you want to execute this script.
#   2. Image, including pathway if needed, to where the watermark is stored.

# Confirm number of arguments - 2: main directory this is run in AND watermark image
if [ $# -ne 0 ]; then
    echo "Please call this script with two arguments. First is the pathway to the directory you want to run this program in. The second is the path to the watermark PNG image you want to use. If either has spaces please put the path in double quotes."
    exit 1
# DIRECTORY: Confirm it's a directory and it exists.
elif [ ! -e "$1" ]; then 
    echo "Directory doesn't exist. Please pass in a valid directory you want the program to run in for the first argument." 
    exit 1
elif [ ! -d "$1" ]; then 
    echo "That isn't a directory. Please pass in a valid directory for the program to run in."
    exit 1
# WATERMARK: Checks if the watermark image exists and then if the last three characters in the name are "png" to check the filetype
elif [ ! -f "$2" ]; then
    echo "The passed in watermark image doesn't exist in your filesystem."
    exit 1
elif [[ ${2:(-3)} != "png" ]]; then
    echo "Your watermark needs to be a PNG image."
    exit 1
fi

# Save the full pathway for the watermark before moving directories
fullWatermarkPath="$PWD/$2"

# Outputs what we're working with
echo -e "\nWorking in directory: $1 \nUsing watermark: $fullWatermarkPath"

# Moves to that directory
cd "$1"
# Checks to see the condition returned and if failed exits the program
if [ $? -ne 0 ]; then
    echo "Couldn't access the directory passed in. Exiting."
    exit 1
fi

# Make a temporary directory
tempDirectory="transitoryDirectory"
mkdir $tempDirectory
# Checks to see the condition returned and if failed exits the program
if [ $? -ne 0 ]; then
    echo "Couldn't create the temporary directory needed. Exiting"
    exit 1
fi

imgTypes=( "*.JPG" "*.jpg" "*.PNG" "*.png" "*.jpeg" "*.JPEG" )
# Move all the image files into the directory
for i in "${imgTypes[@]}"; do
:
   cp $i $tempDirectory/ 2>/dev/null
done

# Moves to be with the newly created images
cd $tempDirectory

# Removes images that don't need to be compressed or watermarked. This includes the original watermark image (in case it was moved in by mistake) along with anything marked with orginal, ignore, collage, (P)interest, or (I)nstagram. The pinterest image will be compressed at the end to a different width with no watermark. The others are just ignored/deleted.
find . \( -name "*original*" -o -name "*ignore*" -o -name "*collage*" -o -name "*interest*" -o -name "*nstagram*" -o -name $2 \) -delete

#Run mogrify cmd with all
mkdir output
# Checks to see the condition returned and if failed exits the program
if [ $? -ne 0 ]; then
    echo "Couldn't create the temporary directory needed. Exiting"
    exit 1
fi
# Added -auto-orient to fix the exif data so the watermark will be applied properly for all images and not rotated
mogrify -auto-orient -path output -resize 750 -quality 100% -define jpeg:extent=70KB * 2>/dev/null

# Moves to output folder with newly compressed images.
cd output

# Renames the files to add the text "compressed_" before all the filenames
find * -exec mv {} "compressed_{}" \;

# Add the watermark to these images
find * | while read img; do
    composite -compose atop -gravity southeast -background none $fullWatermarkPath "$img" "$(basename $img)"
done


# Moves all the images up two folders and removes the temporary directories and images
mv * ../..
cd ../..
rm -rf $tempDirectory

# If there's a Pinterest image it compresses it to the right size and names it the proper way without a watermark
find . -name '*interest*' | while read line; do
     magick convert "$line" -resize 471 -define jpeg:extent=70KB "compressed_${line:2}"
done

#Boom! Have all compressed images with watermark
echo -e "All done. Completed successfully.\nHave a great day!\n"
