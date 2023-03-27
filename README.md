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

File: [compress_my_images.sh](BloggingHelp/compress_my_images.sh)

Input: Path to the folder containing the images you want to batch resize and compress. If there's 
spaces in the path surround this with double quotes.

More information: I wrote a [blog post](https://www.simplykyra.com/2021/03/10/use-a-simple-bash-script-to-resize-your-images-quickly-and-easily/) that 
goes into this script in more detail. Specifically it goes over the script's requirements, input, 
what it does, how you run it, and explains the code, mostly, line by line. If you want more background
information on ImageMagick I [previously posted](https://www.simplykyra.com/2021/01/27/easily-resize-multiple-images-quickly-through-the-terminal-on-your-mac/)
how I use it to resize and compress one or more images at once. 

### Batch Resize, Compress, and Apply Watermark to Images

Just created a script that uses mogrify to compress the image and renames each file like above. It also applies a watermark to each image so you're left with compressed and watermarked images when you run the script. As they're created in a temporary directory and renamed before returned you'll be left with both the original and newly created files. I created the script in two different formats and uploaded both so you can choose which one you want depending how you feel. When I get a chance I'll write a post going over them so if you have any questions let me know. I'll link to the posts when they go live. That said the scripts are:

With arguments: [compress_and_watermark_image_with_arguments.sh](BloggingHelp/compress_and_watermark_image_with_arguments.sh)

Input: There are two arguments. The first is the pathway to the directory that you want the script to execute within. The second is the relative pathway and filename of the PNG image that you want to use to watermark all the images in the previous directory. 

Without arguments: [compress_and_watermark_my_images.sh](BloggingHelp/compress_and_watermark_my_images.sh)

There is no input but there are hardcoded variables that you may want to change. Most are at the top of the file but there is one line further down you may want to update. There's a comment with the line number you'll want to look at along with the other hardcoded variables at the top. Basically you'll want to run this script in the directory you want it to execute on. I made it so I can execute this file from anywhere as I wanted the freedom of running it from different spots. As such the absolute pathway of the watermark PNG file is hardcoded within. If you want to use arguments there's the previous file. I first wrote the one with the arguments and then changed it to work this way. As such some locations in the script have been streamlined.

And one final one. This one takes the idea of the one above with no arguments and allows the ability to compress some images without watermarks. It's found at [compress_watermark_ignore_images.sh](BloggingHelp/compress_watermark_ignore_images.sh)

## reMarkable ##

Back at the end of 2020 I came across the reMarkable2 paper tablet and received it in January 2021. 
I quickly realized that I was able to use SSH to access the device and thus created several blog
posts detailing what I've since learned. If you own a reMarkable and are interested in connecting to it 
here are my previous posts:
* [Learn How to Access Your reMarkable Through the Command Line](https://www.simplykyra.com/2021/02/03/learn-how-to-access-your-remarkable-through-the-command-line/)
* [Switch Out Your reMarkable’s Sleep Screen… Plus Easily Back it Up](https://www.simplykyra.com/2021/02/10/switch-out-your-remarkables-sleep-screen-plus-easily-back-it-up/)
* [How to Make Template Files for Your reMarkable](https://www.simplykyra.com/2021/02/24/how-to-make-template-files-for-your-remarkable/)
* [My reMarkable2 Updated! This Is What I Did Next](https://www.simplykyra.com/2021/04/14/my-remarkable2-updated-this-is-what-i-did-next/)

### Upload PNG Images to the reMarkable and Generate Accompanying JSON Snippet

Are you currently manually uploading PNG images one by one to your reMarkable and then editing the 
templates.json file slowly? I was too so I created a script that looks at the current directory, 
compresses all the directories and their contents, uploads it to your reMarkable, extracts it, generates
the code snippet you'll need for the JSON file, and cleans up after itself. 

File: [Upload_PNG_and_Directories_To_reMarkable.sh](reMarkable/Upload_PNG_and_Directories_To_reMarkable.sh)

Input: Nothing. Although it uses the current directory to run in so you'll want it to live where you want it to run.

Assumptions: 
* Each PNG (future reMarkable template file) needs to be in a single directory within the directory 
the program lives in. This directory becomes the templates's category so if you want it to match one already on 
your reMarkable you'll want it to have the same name. If the image is in the same directory as the script
the category will be assigned `.`
* Your file names don't contain an extra period as I use a period to remove the extension from the filename.

More information: I wrote two blog posts that go into this script in more detail if you're interested.  
* [Quickly Generate a JSON Template Code Snippet for Your reMarkable](https://www.simplykyra.com/2021/03/31/quickly-generate-a-json-template-code-snippet-for-your-remarkable/) - goes over the directory and image organization I use along with the last half of the script that generates the JSON snippet. 
* [Quickly and Easily Upload Template Images to Your reMarkable](https://www.simplykyra.com/2021/04/07/quickly-and-easily-upload-template-images-to-your-remarkable/) - goes over the first half of the script that compresses the images and uploads it to your reMarkable.

### Backup Your reMarkable's Files in One Easy to Execute Script

Created a quick script that sits in my reMarkable backup directory on my computer. Before running it you'll need to enter your IP address on line 5. When run it creates a directory, dated by name, and backups all the files needed. I haven't had a chance to blog about it yet but figured I'd share right away in case useful. 

File: [backupRemarkable.sh](reMarkable/backupRemarkable.sh)

Input: Nothing. Although it uses the current directory to run in so you'll want it to live where you want it to run.

## SwiftUI Examples ##

I created an example of a custom picker that allows for multi-selection. If you're creating a new project to demo it this file would replace your ContentView.swift. It has a main body that checks if you're running on macOS or iOS and runs the proper view. The macOS view shows a button that opens the multi-selection view via a button. The iOS view also opens the multi-selection view but does it through a NavigationLink. As it's for iOS I included sections. Both views show a simple text output to display the selected text. Also both views work on the other device so you can switch them depending what you prefer. You can read more about this [at my post here](https://www.simplykyra.com/how-to-make-a-custom-picker-with-multi-selection-in-swiftui/).

File: [CustomMultiSelectionPicker.swift](SwiftExamples/CustomMultiSelectionPicker.swift)

If you want to have the list of items include an image (or something else) I've updated the previous example to use a customizable struct. The code can be found at [CustomMultiSelectionExampleWithImages](SwiftExamples/CustomMultiSelectionExampleWithImages). The related blog post can be found [here](https://www.simplykyra.com/update-to-my-custom-picker-with-multi-selection-in-swiftui-now-with-images/).
