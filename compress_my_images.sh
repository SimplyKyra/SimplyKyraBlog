#!/bin/bash

# Confirm the proper argument was given; otherwise a blank argument would send you to the home directory
if [ $# -ne 1 ]; then
    echo "Please call this script with a single argument giving me the path of the directory you want to run this in. If it has spaces please put it in double quotes."
    exit 1
elif [ ! -e "$1" ]; then 
    echo "Directory doesn't exist. Please pass in a valid directory you want the program to run in for the first argument." 
    exit 1
elif [ ! -d "$1" ]; then 
    echo "That isn't a directory. Please pass in a valid directory for the program to run in."
    exit 1 
fi

echo -e "\nWorking in directory: $1 "
cd "$1"

# Checks to see the condition returned and if failed exits the program
if [ $? -ne 0 ]; then			
    echo "Couldn't access the directory specified. Exiting."
    exit 1
fi

mkdir output
# Checks to see the condition returned and if failed exits the program
if [ $? -ne 0 ]; then
    echo "Couldn't create the temporary directory needed. Exiting"
    exit 1
fi

# Compress all jpg, jpeg, and png images in the folder. The stderror is sent to null in case some image types aren't available.
mogrify -path output -resize 750 -quality 100% -define jpeg:extent=70KB *.JPG 2>/dev/null 
mogrify -path output -resize 750 -quality 100% -define jpeg:extent=70KB *.jpg 2>/dev/null
mogrify -path output -resize 750 -quality 100% -define jpeg:extent=70KB *.PNG 2>/dev/null
mogrify -path output -resize 750 -quality 100% -define jpeg:extent=70KB *.png 2>/dev/null
mogrify -path output -resize 750 -quality 100% -define jpeg:extent=70KB *.jpeg 2>/dev/null
mogrify -path output -resize 750 -quality 100% -define jpeg:extent=70KB *.JPEG 2>/dev/null

# Moves to be with the newly created folders so they can be renamed
cd output

# Removes the Pinterest (wrong size), Instagram (unneeded) images, and any images ending with 'original' as that shows there's an updated blurred image for the blog.
find . -name "*original*" -delete
find . -name "*ignore*" -delete
find . -name "*interest*" -delete
find . -name "*nstagram*" -delete

# Adds the text compressed_ before all the filenames
find * -exec mv {} "compressed_{}" \;

# Moves all the images up a folder and removes the temporary output folder
mv * .. 
cd .. 
rmdir output

# If there's a Pinterest image it compresses it to the right size and names it the proper wayi
find . -name '*Pinterest*' | while read line; do
     magick convert "$line" -resize 471 -define jpeg:extent=70KB "compressed_${line:2}" 
done

echo -e "All done. Completed successfully.\nHave a great day!\n"
