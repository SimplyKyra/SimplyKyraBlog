#!/bin/bash

##### Variables Used #####

# How do you connect to your reMarkable? I created a shortcut so I connect with "ssh remarkable". Another way might be 
# with "ssh root@IPaddress". Here I left off the "ssh" so it's just "remarkable". In the second case it would be "root@IPaddress"
declare sshReMarkable="remarkable"

# Name of the temporary tar ball that's created
declare archiveName="archivedTemplates.tgz"

##### Error Checking #####

# Checks if there are any directories within the current directory and saves them for here and further down. 
declare currDirectories=$(find . -maxdepth 1 -mindepth 1 -type d)
# If there aren't any directories that would be a problem so it issues a message and exits the program
if [ -z "$currDirectories" ]; then
  echo "Any PNG files to be uploaded needs to be within a directory. This directory shows which category the image belongs to. As there are no directories within your current directory the script is exiting now."
  exit 1
fi

# Saves any nested directories.
declare nestedDirectories=$(find . -mindepth 2 -type d)
# If those nested directories exist a warning is issued and the user choose whether the script should continue or exit. 
if [ -n "$nestedDirectories" ]; then
  echo "This script assumes that all images are within a single directory. It found the following nested directories:"
  echo "$nestedDirectories"
  echo "Should it proceed and you do any needed cleanup after (in the reMarkable template directory and the generated JSON snippet) or do you want to stop?"
  read -p 'Press y to continue. Anything else to stop the script: ' resp
  echo "$resp"
  if [ "$resp" != "y" ]; then
    exit 1
  fi
fi

##### Upload the PNG files to the reMarkable #####

# Empty string to store the directory names we need to create the tarball from 
declare directoryString=""

# Goes through the current directories and stores their names, with minor formating, to the $directoryString variable.
for f in $currDirectories; do  
  directoryString="$directoryString -name $(basename $f) -o"
done

# Creates, informs, and executes a command to compress the directories and their image files. 
declare compressCommand="find . -maxdepth 1 -mindepth 1 -type d \(${directoryString%??}\) -exec tar cfz $archiveName {} +"
echo "Compressing the directories and files within using this command: $compressCommand"
eval "$compressCommand"

# Uploads the created tarball to the reMarkable's templates directory. 
eval "scp $archiveName $sshReMarkable:/usr/share/remarkable/templates/"

# Creating a command that will ssh into the reMarkable, navigate to the templates folder, extract the tarball, and remove it. 
# In case it doesn't perform correctly I output the command to you before executing it.
declare executeSSHcommands="ssh $sshReMarkable \"cd /usr/share/remarkable/templates/ && tar -xf $archiveName && rm $archiveName\""
echo "About to execute $executeSSHcommands"
eval "$executeSSHcommands"

# Removes the tarball within the current directory as it's no longer needed.
rm $archiveName

##### Generate the JSON snippet #####

# Creates an empty string to store the JSON snippet as it's being assembled.
declare jsonString=""

# Uses find to find any PNG images within the current directory and any 
# sub-directories. It then uses each filename (within the while statement) 
# to generated the needed templates.json code snippet.
for f in $(find . -iname "*.PNG" | sort); do
  jsonString="$jsonString,\n    {\n"
  # Creates a variable and saves the name, taken from the filename, to a variable. There are two ways: 
  # This is the way I did it before when I wanted full names for the templates. It splits the name based on capital letters while taking into account some instances like FAQ. 
  #    Example: "BalancedLifeResetJournal5" would become "Balanced Life Reset Journal 5"
  # declare name=$((basename $f | cut -f 1 -d '.' | sed -e 's|\([A-Z0-9][^A-Z0-9]\)| \1|g' -e 's|\([a-z]\)\([A-Z0-9]\)|\1 \2|g') | sed -e 's/^[[:space:]]*//');
  # I chose to shorten my names and went with abbreviations. Since that would make it more difficult I now simply split the name by replacing the dash (-) with a space
  declare name=$(basename $f | cut -f 1 -d '.' | sed 's,\-, ,g')
  jsonString="$jsonString\n      \"name\": \"${name//_}\","
  # Takes the last folder before the filename as the parent directory.
  declare directoryName=$(basename $(dirname $f));
  jsonString="$jsonString\n      \"filename\": \"$directoryName/$(basename $f  | cut -f 1 -d '.')\","
  jsonString="$jsonString\n      \"iconCode\": \"\ue9d8\","
  jsonString="$jsonString\n      \"landscape\": \"false\","
  jsonString="$jsonString\n      \"categories\": ["
  jsonString="$jsonString\n        \"${directoryName//-/ }\""
  jsonString="$jsonString\n      ]"
  jsonString="$jsonString\n    }"
done

# Outputs the text to a new file named "myJSONsnippet.txt so you can use the JSON snippet at your leisure. 
echo -e "$jsonString" > myJSONsnippet.txt
# Also sends the snippet to your clipboard so you can paste it in right away without needing to open the file.
echo -e "$jsonString" | pbcopy
