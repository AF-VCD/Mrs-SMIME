#!/bin/bash

if [ "$1" = '-h' ] || [ "$1" = '--help' ]; then { echo "This script is meant to be run interactively without arguments."; exit 0; } fi


#Prompt user to select email.
# Leveraging applescript for prompts
echo "Prompting user for p7m file..."
p7mFile=$(osascript -e 'tell application (path to frontmost application as text)
set myFile to choose file of type {"dyn.ah62d4rv4ge81ar5r"} with prompt "Select p7m file to decrypt"
POSIX path of myFile
end')
if [ $? -ne 0 ]; then { echo 'p7m file was not selected' ; exit 1; } fi
echo $p7mFile
# The strange file type was determined by running the command:
#  osascript -e 'info for "./smime.p7m"'


echo "Prompting user for output folder..."
outFolder=$(osascript -e 'tell application (path to frontmost application as text)
set outFolder to choose folder with prompt "Please select or create a folder to store the output:"
POSIX path of outFolder
end')
if [ $? -ne 0 ]; then { echo 'Output folder was not selected' ; exit 1; } fi
echo $outFolder


echo "Decrypting and decoding file ..."
decrypted="$outFolder/decrypted.smime"

# - Decrypts file using native mac stuff
# - Removes MIME headers 
# - Removes new lines
# - Decodes out of base 64 
# - Strips 55 bytes of digital signature (probably) from the front of file
# - Outputs to 'decrypted.smime' in the selected output folder
security cms -D -i "$p7mFile" \
  | sed '/Content-.*$/d' \
  | sed 's/\r$//' \
  | base64 -d \
  | tail -c +55 > "$decrypted" 
if [ $? -ne 0 ] || [ ! -s "$decrypted" ] ; then { echo 'Failed to decrypt or decode file' ; exit 1; } fi


echo "Decoding file..."
python3 "$(dirname $0)/mimesplit.py" -d "$outFolder" "$decrypted"
if [ $? -ne 0 ] ; then { echo 'Failed to decode file' ; exit 1; } fi

echo "Script complete. Files located at '$outFolder'"