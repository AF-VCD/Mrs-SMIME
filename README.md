# Mrs-SMIME

This is a bash script that can be used to manually decrypt email messages with a smartcard on Macs. It is intended for Air Force employees, but may also be usable by other people in government service.


## Instructions
In order to utilize this tool, follow the steps in the two sections below: 

### Getting S/MIME File:
1. Go to your webmail and find the offending encrypted email that you can't open. 
1. You should see that the email has an attachment called "smime.p7m"
1. Download that attachment somewhere to your computer. This is the encrypted version of the email you can't open, and includes attachments as well.

### Getting and using script:
1. Download .sh and .py scripts from this github repository, put them in the same folder on your computer
1. Open a terminal in the folder and run the shell script: `bash mrs-smime.sh`
1. On the first file selection window, select the "smime.p7m" file you downloaded earlier
1. On the second file window, choose or create a folder to save the raw decrypted text output
1. Enter your pin when prompted
1. Wait for the script to complete

The script produces a few things:

1. A `decrypted.smime` file, which is the direct result of decrypting the p7m file. 
1. Two versions of the email body, one as text and one as HTML
1. All other attachments of the email

## Notes on implementation and usage
- This only works on Mac, not Linux or Windows. In order for this to work, 
your computer needs to at least be able to access webmail (have correct certificates, etc).
- For Windows 10 see the related project: Mr-SMIME.
- My script does not see anything related to your card, like your PIN; that part is 
handled by native Apple security libraries. The script tells the Mac to decrypt the email, 
and the Mac figures out that it can't decrypt the email without the PIN, and asks you for it on its own.
- No information whatsoever is transmitted from this script to anywhere on the internet.