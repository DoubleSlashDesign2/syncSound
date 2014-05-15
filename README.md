#syncSound.lua#

Note: This module works with Corona SDK v2014.2189 and newer.
It has only been tested with Corona Graphics 2.0.

Based on Electric Eggplant's Synchronied Text to Speech framework
Development starting point was Electric Eggplant's syncSound version 3.2 - for K2 (7/22/12)
[Available Here](http://www.raywenderlich.com/19415/how-to-make-an-interactive-ebook-without-any-code)

Developed by Little Pup Studios - Joey Defourneaux

--------------------------------------------------------------
##Change log##
version 4.0 - (5/14/14)  
+ Rewrite Electric Eggplant's original code to current Corona SDK and LUA module implimentation standards.
+ Added the ability to import audio and audio text files directly from audacity export files (no more hardcoding in the text).

--------------------------------------------------------------

###Overview###

syncSound.lua is a Corona SDK module to add audio/video narration functionality with a couple simple function calls.
syncSound adds the following functionality:

+ Import audio and text directly from Audacity export files (no hardcoding)
+ Define text size/color/position
+ Define the highlighting text color
+ Ability to add a text bubble background behind the text
+ Choose the background bubble color and alpha values (if the background bubble is enabled)
+ Define the audio volue and channel
+ Choose to have the text highlighted in sync with audio narration
+ Add the ability to click each word and have just that word spoken and highlighted
+ syncSound function returns all text as a single displayGroup object so it can be manipulated together
+ Select the direction text should be read (left to right or right to left) and alter position automatically

Now you can record your book's text, label the audio tracks, and simply import those files to add the text to your app (and so much more!)

--------------------------------------------------------------

###Installation###

The syncSound.lua file must be in the root directory of your Corona project.
Import the syncSound modlue by setting a variable to the require("syncSound") value.
Ex. `local syncSound = require("syncSound")`

--------------------------------------------------------------

###Gotchas###

+ All time values are given in milliseconds except tagged text start/stop values (which are in seconds)
+ Color values must be in an RGB table { 0, 0, 0 }
+ Color values are Corona Graphics 2.0 compatible (must be values between 0 and 1)

--------------------------------------------------------------

###Functions###
syncSound currently has two public functions

1. syncSound.AddSentence()
2. syncSound.SaySentence()

--------------------------------------------------------------

###syncSound.AddSentence({options}) - Syntax###

syncSound.AddSentence requires a table of options. Parameters are listed below:

__audioFile__ (required)

This is the name of the audio file (including the file extension). The file name must be enclosed in quotes.

__audioDir__ (required)

This is the directory where the audio file is located (with respect to the applications root folder). The folder name must be enclosed in quotes.

__audacityFile__ (required if true)

This is a _boolean_ flag that tells the module if you are importing an audacity label text file with the audio file. Default value is false.

__words__ (required)

If __audacityFile__ is true, __words__ is the name of the labels text file (including the file extension). It must be located in the same audio directory as the audio file.

If __audacityFile__ is false or not set, __words) is a table of tables that contains start times, stop times, and words to be used as the text. Start and stop times are in seconds. The table format must be as follows:

    text = {

        {start =  0.5805, out = 0.2786, name = "Here"},    
        {start =  0.3018, out = 0.3889, name = "is"},

    }

__fadeDuration__ (optional)

This is the duration of fade-in effect that transitions the text on the screen. Time is given in _milliseconds_.
Default value is 1000ms.

__channel__ (optional)

This is the audio channel used to play the individual words narration audio file. Acceptable values are between 1 and 32.
Default value is 16.

__volume__ (optional)

This is the volume level that the individual words narration audio will be played. Values are between 0 and 1.
Default value is 1.

__font__ (optional)

This is the font that will be used to display the text.
Default value is native.systemFont.

__fontColor__ (optional)

This is the color that will be used for the normal text. Values must be given as an RGB table of values between 0 and 1.
Default value is { 0, 0, 0 } which is black.

__fontColorHi__ (optional)
This is the color that will be used to highlight the text. Values must be given as an RGB table of values between 0 and 1.
Default value is { 0, 0, 1 } which is blue.

__fontSize__ (optional)

This is the value that will be used for the font size. Acceptable values are _ints_.
Default value is 24.

__padding__ (optional)

This is the pixel spacing between the start of the displayGroup and the start of the actual text. Accepable values are _ints_.
Default value is 20.

__lineOffset__ (optional)

This is the pixel spacing between lines of text (if text is more than one line). Acceptable values are _ints_.
Default value is 0. (standard offset distance)

__background__ (optional)

This is a _boolean_ flag that indicates if you want to include a text bubble background behind the text.
Default value is false.

__backgroundAlpha__ (optional)

This is the alpha level of the background text bubble (if background is set to true). Acceptable values are between 0 and 1.
Default value is 0.

__backgroundColor__ (optional)

This is the color for the background text bubble (if background is set to true). Values must be given as an RGB table of values between 0 and 1.
Default values is { 1, 1, 1 } which is white.

__readDir__ (optional)

This is the direction text should be read. Optional values are "leftToRight" and "rightToLeft".
Default values is "leftToRight".

__canTapWords__ (optional)

This _boolean_ flag indicates if you want each word to be tappable. Tapping a word will play a seperate audio file of just that word being spoken. 
Default value is false.

If this flag is set to true, you must also upload a seperate audio file for each unique word in the complete text. The unique word files must be located in a subdirectory called "words" in the audio directory (ex. ~/audio/words/uniqueword.mp3). The name of each unique word audio file must be the 'name' value of the word in all lowercase letters.
Note: This feature currently only supports MP3 file format.

###Returned Values###
syncSound.AddSentence returns two values.

1. A dataObject that contains a modified version of all field values listed above.
2. A Corona _displayGroup_ that contains the _displayObjects_ of the words in the text.

--------------------------------------------------------------

###syncSound.SaySentence({options}) - Syntax###

syncSound.SaySentence requires a table of options. Parameters are listed below:

__wordsObject__ (required)

This is the dataObject that is the first returned value from _syncSound.AddSentence_.

__delayNarration__ (optional)

This is a delay from the time the _syncSound.SaySentence_ function is called until the narration audio begins to play. Time is given in _milliseconds_.
Default is 500ms.

__fadeDuration__ (optional)

This is the amount of time the highlighting word takes to fade into alpha=1. Time is given in _milliseconds_.
Default value is 100ms.

__channel__ (optional)

This is the channel on which the complete audio narration is played. Acceptable values are between 1 and 32.
Default value is 16.
Note: It is recommmended that this value be the same as the channel value set in the _syncSound.AddSentence_ function.

__volume__ (optional)

This is the volume at which the complete audio narration is played. Acceptable values are between 0 and 1.
Default value is 1.
Note: It is recommmended that this value be the same as the volume value set in the _syncSound.AddSentence_ function.

###Returned Values###
None

--------------------------------------------------------------

###Examples###

Example code as been included in the main.lua file of this repo.
Note: The included example uses the Audacity file import method. If you are trying to hardcode in word table values and are having trouble with the format, please look at the Audacity labels text file named "fullAudio.txt" located in the audio folder.
Text tables must be in the format:

    text = {

        {start =  0.5805, out = 0.2786, name = "Here"},    
        {start =  0.3018, out = 0.3889, name = "is"},

    }

with each word of text being its own table. The tags for each value are required.
