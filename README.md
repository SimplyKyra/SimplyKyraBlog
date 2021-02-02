# SimplyKyraBlog
Bits of code that I'm sharing with the world to hopefully make your life a little easier!

## Blogging Help

### Batch Resize and Compress Images

Are you looking to resize multiple images, based on their pixel width, and compress them down all 
at once? I created a simple bash script that allows me to do this for any images I want to upload 
to my blog. The script resizes all files with an extension of jpeg, jpg, or png to 750 pixels wide (height 
resizes relative) and compresses them to less than 70KB each. It then removes any compressed files 
with the substring "interest" (for P/pinterest) and "nstagram" (for I/instagram). If you have a 
file containing the substring "nterest" it specifically resizes it to 471 pixels wide and compresses
it. I've commented the code so you can easily copy this to your device and use it as a starting 
spot for what you want to use it for. 

File: [compress_my_images.sh](https://github.com/SimplyKyra/SimplyKyraBlog/blob/main/compress_my_images.sh)

Input: Path to the folder containing the images you want to batch resize and compress. If there's 
spaces in the path surround this with double quotes.

