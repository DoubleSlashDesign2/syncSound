-- Testing files for syncSound.lua Corona SDK module
-- Based on Electric Eggplant's Synchronied Text to Speech framework
-- Development starting point was Electric Eggplant's syncSound version 3.2 - for K2 (7/22/12)

-- Continued development by Little Pup Studios (starting 5/10/14)

---------------------------------------------------------------------------------
-- File: main.lua
-- Testing framework for syncSound module.
---------------------------------------------------------------------------------

-- hide status bar
display.setStatusBar( display.HiddenStatusBar )

---------------------------------------------------------------------------------
-- Debugging Code
---------------------------------------------------------------------------------
-- turn on debugging
local debugMode = true

--
-- this little snippet will make a copy of the print function
-- and now will only print if debugMode is true.
-- quick way to clean up your logging for production
--
reallyPrint = print
function print(...)
    if debugMode then
        reallyPrint(unpack(arg))
    end
end

---------------------------------------------------------------------------------
-- Requires
---------------------------------------------------------------------------------
local syncSound = require( "syncSound" )

---------------------------------------------------------------------------------
-- Local forwarding references go here
---------------------------------------------------------------------------------
local bg
local testText
local testAudio = audio.loadStream( "audio/fullAudio.mp3" )
local testFile = "audio/fullAudio.txt"

-- example text table if not using the Audacity File import method
testText = {
    {start = 0.277719, out = 0.474610, dur = 0, name = "This"},
    {start = 0.474610, out = 0.721241, dur = 0, name = "is"},
    {start = 0.721241, out = 1.063209, dur = 0, name = "test"},
    {start = 1.063209, out = 1.587560, dur = 0, name = "audio"},
    {start = 1.587560, out = 1.867352, dur = 0, name = "for"},
    {start = 1.867352, out = 2.447661, dur = 0, name = "Corona"},
    {start = 2.447661, out = 3.146105, dur = 0, name = "SDK"},
    {start = 3.146105, out = 3.809315, dur = 0, name = "module"},
    {start = 3.809315, out = 4.812421, dur = 0, name = "syncSound."}
}

-- plain white background to put the text against
bg = display.newRect( 0, 0, 1200, 800 )
bg.x = display.contentCenterX
bg.y = display.contentCenterY
bg:setFillColor( .8, .8, .8 )

-- add the test text
local wordsObject, textDisplayGroup = syncSound.AddSentence( { background=true, backgroundAlpha=1, audacityFile=true, words=testFile, audioFile=testAudio, audioDir = "audio", fadeDuration=500, x=50, y=200, canTapWords=true } )
-- play the test narration
syncSound.SaySentence( { narration=true, wordsObject=wordsObject } )
