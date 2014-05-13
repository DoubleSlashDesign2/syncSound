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
local testAudio = audio.loadStream( "audio/audio.mp3" )
local testFile = "audio/audio.txt"
local nothing = {.5, .5, .5}
local color = nothing or {1, 1, 1}

-- plain white background to put the text against
bg = display.newRect( 0, 0, 1200, 800 )
bg.x = display.contentCenterX
bg.y = display.contentCenterY
bg:setFillColor( .8, .8, .8 )

-- test text for testing the add sentance function
local wordsObject, textDisplayGroup = syncSound.AddSentence( { audacityFile=true, words=testFile, audioFile=testAudio, audioDir = "audio", fadeDuration=500, x=0, y=0 } )
--local wordsObject, textDisplayGroup = syncSound.AddSentence( { words=testText, audioFile=testAudio, audioDir = "audio", fadeDuration=500, x=0, y=0 } )
syncSound.SaySentence( { narration=true, wordsObject=wordsObject } )