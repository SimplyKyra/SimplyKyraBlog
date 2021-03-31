# SimplyKyraBlog
Bits of code that I'm sharing with the world to hopefully make your life a little easier!

## Blogging Help

Any scripts that help me while going through my blogging related tasks.

### Batch Resize and Compress Images

Are you looking to resize multiple images, based on their pixel width, and compress them down all 
at once? I created a simple bash script that allows me to do this for any images I want to upload 
to my blog. The script resizes all files with an extension of jpeg, jpg, or png to 750 pixels wide (height 
resizes relative) and compresses them to less than 70KB each. It then removes any compressed files 
with the substring "interest" (for P/pinterest) and "nstagram" (for I/instagram). If you have a 
file containing the substring "nterest" it specifically resizes it to 471 pixels wide and compresses
it. I've commented the code so you can easily copy this to your device and use it as a starting 
spot for what you want to use it for. 

File: [compress_my_images.sh](compress_my_images.sh)

Input: Path to the folder containing the images you want to batch resize and compress. If there's 
spaces in the path surround this with double quotes.

More information: I wrote a [blog post](https://www.simplykyra.com/2021/03/10/use-a-simple-bash-script-to-resize-your-images-quickly-and-easily/) that 
goes into this script in more detail. Specifically it goes over the script's requirements, input, 
what it does, how you run it, and explains the code, mostly, line by line. If you want more background
information on ImageMagick I [previously posted](https://www.simplykyra.com/2021/01/27/easily-resize-multiple-images-quickly-through-the-terminal-on-your-mac/)
how I use it to resize and compress one or more images at once. 

## reMarkable ##

Back at the end of 2020 I came across the reMarkable2 paper tablet and received it in January 2021. 
I quickly realized that I was able to use SSH to access the device and thus created several blog
posts detailing what I've since learned. If you own a reMarkable and are interested in connecting to it 
here are my previous posts:
* [Learn How to Access Your reMarkable Through the Command Line](https://www.simplykyra.com/2021/02/03/learn-how-to-access-your-remarkable-through-the-command-line/)
* [Switch Out Your reMarkable’s Sleep Screen… Plus Easily Back it Up](https://www.simplykyra.com/2021/02/10/switch-out-your-remarkables-sleep-screen-plus-easily-back-it-up/)
* [How to Make Template Files for Your reMarkable](https://www.simplykyra.com/2021/02/24/how-to-make-template-files-for-your-remarkable/)

### Upload PNG Images to the reMarkable and Generate Accompanying JSON Snippet

Are you currently manually uploading PNG images one by one to your reMarkable and then editing the 
templates.json file slowly? I was too so I created a script that looks at the current directory, 
compresses all the directories and their contents, uploads it to your reMarkable, extracts it, generates
the code snippet you'll need for the JSON file, and cleans up after itself. 

File: [Upload_PNG_and_Directories_To_reMarkable.sh](Upload_PNG_and_Directories_To_reMarkable.sh)

Input: Nothing. Although it uses the current directory to run in so you'll want it to live where you want it to run.

Assumptions: 
* Each PNG (future reMarkable template file) needs to be in a single directory within the directory 
the program lives in. This directory becomes the templates's category so if you want it to match one already on 
your reMarkable you'll want it to have the same name. If the image is in the same directory as the script
the category will be assigned `.`
* Your file names don't contain an extra period as I use a period to remove the extension from the filename.

More information: I wrote two blog posts that go into this script in more detail if you're interested. One was just posted and the other will post next week. 
* [Quickly Generate a JSON Template Code Snippet for Your reMarkable](https://www.simplykyra.com/2021/03/31/quickly-generate-a-json-template-code-snippet-for-your-remarkable/) - goes over the directory and image organization I use along with the last half of the script that generates the JSON snippet. 
* Quickly and Easily Upload Template Images to Your reMarkable (Will link when it posts) - goes over the first half of the script that compresses the images and uploads it to your reMarkable.
