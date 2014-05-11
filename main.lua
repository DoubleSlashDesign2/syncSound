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
-- local forwarding references go here
---------------------------------------------------------------------------------
local bg
local testText
bg = display.newRect( 0, 0, 1200, 800 )
bg.x = display.contentCenterX
bg.y = display.contentCenterY
bg:setFillColor( 1, 1, 1 )

testText = {
    {start = 0.277719, out = 0.474610, dur = 0, name = "This"},
    {start = 0.474610, out = 0.721241, dur = 0, name = "is"},
    {start = 0.721241, out = 1.063209, dur = 0, name = "test"},
    {start = 1.063209, out = 1.587560, dur = 0, name = "audio"},
    {start = 1.587560, out = 1.867352, dur = 0, name = "for"},
    {start = 1.867352, out = 2.447661, dur = 0, name = "Corona"},
    {start = 2.447661, out = 3.146105, dur = 0, name = "SDK"},
    {start = 3.146105, out = 3.809315, dur = 0, name = "module"},
    {start = 3.809315, out = 4.812421, dur = 0, name = "syncSound."},
}
