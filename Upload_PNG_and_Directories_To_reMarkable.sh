#!/bin/bash

##### Variables Used #####

# How do you connect to you're reMarkable. I use a shortcut so I do "ssh remarkable". Another way might be "ssh root@IPaddress"
# Leave off the ssh so in my case it would just be "remarkable". 
declare sshReMarkable="remarkable"

# Name of the temporary tar ball that's created
declare archiveName="archivedTemplates.tgz"

##### Error Checking #####

# Checks if there's any directories in the current directory and saves them for here and further down. 
declare currDirectories=$(find . -maxdepth 1 -mindepth 1 -type d)
# If there aren't any directories it issues a message and exits the program
if [ -z "$currDirectories" ]; then
  echo "Any PNG files needs to be within a directory. This directory would show what category the image belongs to. There are no directories in your current directory. Exiting the program."
  exit 1
fi

# Saves any nested directories and if they exist issues a warning and asks if the user wants to continue or exit. 
declare nestedDirectories=$(find . -mindepth 2 -type d)
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

declare compressCommand="find . -maxdepth 1 -mindepth 1 -type d \(${directoryString%??}\) -exec tar cfz $archiveName {} +"
echo "Compressing the directories and files within using this command: $compressCommand"
eval "$compressCommand"

# Copies the created tarball to the remarkable. 
eval "scp $archiveName $sshReMarkable:/usr/share/remarkable/templates/"

# Creating a command that will ssh into the reMarkable, navigate to the templates folder, extract the tarball, and remove it. 
# In case it doesn't perform correctly I output it to you and then execute it.
declare executeSSHcommands="ssh $sshReMarkable \"cd /usr/share/remarkable/templates/ && tar -xf $archiveName && rm $archiveName\""
echo "About to execute $executeSSHcommands"
eval "$executeSSHcommands"

# Removes the tarball on my device as it's no longer needed.
rm $archiveName

##### Generate the JSON snippet #####

# Creates an empty string to store the JSON snippet as it's being assembled.
declare jsonString=""

# Uses find to find any PNG images within the current directory and any 
# sub-directories. It then uses each filename (within the while statement) 
# to generated the needed templates.json code snippet.i
for f in $(find . -iname "*.PNG" | sort); do
  jsonString="$jsonString,\n    {\n"
  # Creates a variable and saves the name, taken from the filename, to the variable. Used in the next line
  # This is the way I create the name if you use full words with Capitals to separate. Ex. BalancedLifeResetJournal5 --> Balanced Life Reset Journal 5
  #declare name=$((basename $f | cut -f 1 -d '.' | sed -e 's|\([A-Z0-9][^A-Z0-9]\)| \1|g' -e 's|\([a-z]\)\([A-Z0-9]\)|\1 \2|g') | sed -e 's/^[[:space:]]*//');
  # Instead of above I went simple and it splits the name on the - and adds a space
  declare name=$(basename $f | cut -f 1 -d '.' | sed 's,\-, ,g')
  jsonString="$jsonString\n      \"name\": \"${name//_}\","
  # basename removes the pathway so you're left with the filename and extension. After the | it removes the stuff after the period so you only have the filename
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

# Outputs the text line to the text editor so you can use the snippet at your leisure
# Also sends it to your clipboard so you can paste it in right away without opening the file. 
# Use -e so it sees the new line characters and encircle $jsonString in quotes so it sees the spaces. Ignores the tab otherwise. 
echo -e "$jsonString" > myJSONsnippet.txt
echo -e "$jsonString" | pbcopy



