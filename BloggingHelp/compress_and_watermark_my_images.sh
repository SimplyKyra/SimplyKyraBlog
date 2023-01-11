#!/bin/bash

# Run as: ./compress_and_watermark_my_images.sh
# Assumes you are running the script where you want it to execute. The image location is hardcoded below to the variable "watermark"

## All hardcoded variables you may want to customize
# Hardcoded location of the watermark PNG image
watermark="/Users/kyra/Development/SimplyKyraBlog/Watermark.png"
# Image types we look for to compress and watermark
imgTypes=( "*.JPG" "*.jpg" "*.PNG" "*.png" "*.jpeg" "*.JPEG" )
# Temporary directory we work in. Will be deleted when done.
tempDirectory="transitoryDirectory"
# Go to line 55 to alter the text in the image files that will be ignored (deleted). 

## Checks before running
# Confirm that there are no arguments
if [ $# -ne 0 ]; then
    echo "This script doesn't take in any arguments. Please execute it where you want it run. The watermark is hardcoded to \"$watermark\". If you want a version of the script where you can pass in the directory and/or watermark image please check my other version on GitHub at \"https://github.com/SimplyKyra/SimplyKyraBlog\". Thanks."
    exit 1
# Checks if the watermark image is a PNG file
elif [[ $watermark != *.png ]]; then
    echo "Your watermark needs to be a PNG image. It's currently: $(basename $watermark)."
    exit 1
# Checks if the image exists
elif [ ! -f $watermark ]; then
    echo "The watermark image doesn't exist in your filesystem. It's looking for: $watermark"
    exit 1
# Checks if temporary directory already exists; it shouldn't
elif [ -d $tempDirectory ]; then
    echo "The temporary directory already exists here. If you want to run anyway you'll need to rename or delete the following directory: $tempDirectory"
    exit 1
fi

# Outputs where we are working and with what watermark.
echo -e "\nWorking in directory: $PWD \nUsing watermark: $watermark"

# Make the temporary directory we're going to work in
mkdir $tempDirectory
# Checks to see the condition returned and if failed exits the program
if [ $? -ne 0 ]; then
    echo "Couldn't create the temporary directory needed. Exiting"
    exit 1
fi

# Moves all the image files into the directory
for image in "${imgTypes[@]}"; do
:
   cp $image $tempDirectory/ 2>/dev/null
done

# Moves to be in with all the newly created images
cd $tempDirectory

# Removes images that don't need to be compressed or watermarked. This includes the original watermark image (in case it was moved in by mistake) along with anything marked with orginal, ignore, collage, (P)interest, or (I)nstagram. The pinterest image will be compressed at the end to a different width with no watermark. The others are just deleted so it appears as if they are merely ignored.
find . \( -name "*original*" -o -name "*ignore*" -o -name "*collage*" -o -name "*interest*" -o -name "*nstagram*" \) -delete

# Runs the mogrify command on all * the images in the directory and overwrites them as path is set to ".". I added -auto-orient this time around to fix the exif data so the watermark will be applied properly for all images. Without it the watermark is right for the images in landscape mode and turned on it's side for the ones in portrait mode.
mogrify -auto-orient -path . -resize 750 -quality 100% -define jpeg:extent=70KB * 2>/dev/null

# Add the watermark to these images and rename the resulting file by adding "compressed_" to the front of it
find * -exec composite -compose atop -gravity southeast -background none $watermark {} "compressed_{}" \;

# Moves the newly compressed screen shot images up a directory
find * -exec mv {} "../compressed_{}" \;

# Moves up to join the files and deletes the temporary directory with the newly made images
cd ..
rm -rf $tempDirectory

# If there's a Pinterest image it compresses it to the right size and names it the proper way without a watermark
find * -name "*interest*" -exec magick convert {} -resize 471 -define jpeg:extent=70KB "compressed_{}" \;

#Boom! Have all compressed images with watermark
echo -e "All done. Completed successfully.\nHave a great day!\n"
