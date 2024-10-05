# No Man's Sky Screenshot Annotator

Welcome to Quol's No Man's Sky screenshot annotater. 
The purpose of this tool is to annotate screenshots by adding the galaxy name and the player's name to the top of the screenshot to help catalog findings. It is recommended that you use Steam's F12 when capturing screenshots as this will capture the portal address, and then the annotator adds the galaxy name to the screenshot to help catalog findings throughout your journey.

## how it works

This script will simply check the steam screenshot folder for any new screenshots, and then add the annotations to them and save the newly edited screenshot to a new directory. this way the original screenshot is not modified at all. By default, the annotated screenshots will be placed in an "annotated" folder in the same directory as your Steam screenshots using the same name as the original.

When you execute the script, the script will ask you which galaxy it should use for the galaxy name. All that is needed is to enter the numeric index corresponding to the NMS galaxy (press P to see all 263 NMS galaxy names and numeric ID's). After you confirm the galaxy name, the script will simply run in the background, checking for new screenshots every 15 seconds (by default). If a new screenshot is found, it will automatically annotate it by adding your player name, galaxy name, and saving it in the "Annotated" folder.

## Galaxy Names
All 263 galaxie names are pre-entered. All you have to do is to select the corresponding ID. To see the full list, simply press P at "Enter Galaxy Index" prompt that is displayed when running the script. This will show you the full list. Find the Galaxy, and you will see the index. 

Examples:
* enter "1" for Euclid
* enter  "10" for Eissentam

## Requirements

* Windows 10 or 11
    * powershell (included in windows 10/11)
    * a powershell execution policy that allows you to run the script
        * Set-ExecutionPolicy Unrestricted (allows you to run all scripts - be carefull!)
        * call the script via the following command line:
            * powershell -ExecutionPolicy Bypass -File nms-screenshot.ps1
* ImageMagick
    * download from ImageMagick's site and install or use winget:
        * winget install ImageMagick.ImageMagick


## installation

Once you have ImageMagick installed, then all that is needed is to download a copy of this script, and place it anywhere you want on your computer. You can download by clicking on the "nms-screenshot.ps1" file above, and then selecting "download" from the "..." menu on the right.

Once downloaded, modify the following variables located at the top of the file (open in any text editor - like notepad or visual studio code):

### $screenShotPath
this should be set to the patch where steam places your screenshots when you press F12 in-game. if unsure where they are placed, in Steam click on one of your screenshots, and the Steam screenshot manager should open. Click on the little folder icon next to the game dropdown, and that should open the windows file explorer. Update the $screenShotPath varaiable with this location.

### $addPlayerName
set to $true to add your playername to the top right of your screenshots

### $playerName
set to your desired player name. this is the name that will be added to the top right corner of your screenshots

### $SecondsToSleep
this is the amount of seconds to that the script sleeps before checking for new screenshots

## usage

with the file downloaded and variables updated, all that is needed is to execute the script from a powershell console. Open a powershell console, navigate to the correct directory (hint: open the windows file explorer and browse to the folder where you placed the script and then type "powershell" in the navigation bar at the top. this will open powershell in the same directory that file explorer is displaying).

To execute the scipt, enter the following line and press enter:

* .\nms-screenshot.ps1

or you can just start typing "nms" and press your tab key, and the command auto-comlete should take care of the rest for you.

if you do not want to change the default execution policy to unrestricted, then you can still run this script with a command like:

* powershell -ExecutionPolicy Unrestricted -File .\nms-screenshot.ps1

The script is pretty simple, all that is needed is to select the galaxy by entering the appropriate ID, and then it will just run in the background and check for screenshots that need to be annotated. That's it.