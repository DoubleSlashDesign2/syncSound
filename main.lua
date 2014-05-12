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
local data = {}

-- plain white background to put the text against
bg = display.newRect( 0, 0, 1200, 800 )
bg.x = display.contentCenterX
bg.y = display.contentCenterY
bg:setFillColor( 0.7, 0.7, 0.7 )

-- test text for testing the add sentance function
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

--syncSound.AddSentence{ words=testText, audio=testAudio, audioDir = "audio", fadeDuration=500, x=0, y=0 }

local file = io.open( "audio/audio.txt", "r" )

local i = 1
for line in file:lines() do
    --print( line )
    data[i] = {}
    --local temp, temp2, temp3 = string.match( line, '(%S+)%s*(%S+)%s*(%S+)' )
    --print( temp, temp2 )
    data[i].start, data[i].out, data[i].name = string.match( line, '(%S+)%s*(%S+)%s*(%S+)' )
    -- data[i].start = start
    -- data[i].out = out
    -- data[i].name = name
    print( data[i].name )
    i = i + 1
end
--print( data[1].name )
