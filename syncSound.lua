---------------------------------------------------------------------------------
-- File: syncSound.lua
-- Corona SDK module for displaying text and syncing audio narration to visual highlighting of the displayed text
---------------------------------------------------------------------------------
-- Based on Electric Eggplant's Synchronied Text to Speech framework
-- Development starting point was Electric Eggplant's syncSound version 3.2 - for K2 (7/22/12)
-- Original file available here:
-- http://www.raywenderlich.com/19415/how-to-make-an-interactive-ebook-without-any-code

-- Continued development by Little Pup Studios (starting 5/9/14)

---------------------------------------------------------------------------------
-- Change log
---------------------------------------------------------------------------------
-- version 4.0 - (5/11/14) - Rewrite Electric Eggplant's original code to current Corona SDK and LUA module implimentation standards

local M = {} -- init module table


local function DisplayText( params ) -- private function that uses the words loaded in M.addSentence to create a display object for each word
	print( "step 2 - create word display objects" )

	local words = params.words -- list of the words
	local x = params.x
	local y = params.y
	local font = params.font
	local fontSize = params.fontSize
	local fontColor = params.fontColor -- font color for the words
	local fontColorHi = params.fontColorHi -- font color for the highlighted word
	local group = params.group -- display group for the displayed objects
	local canTapWords = params.canTapWords -- bool indicating if the individual words are tappable
	local xOffset = 0 -- new offset distance between words
	local wordsTable = {} -- table to hold the individual word display objects
	local lineSpacing = fontSize*1.33 -- spacing between the lines of text
	local wordSpacing = fontSize/5 -- spacing between the words
	local wordName = "" -- characters in the word (for finding the individual word audio files automatically)
	local wordAudioDir = params.audioDir .. "/words/" -- directory for the individual word audio files
	local readDir = params.readDir
	local newX -- new x pos, will include spacing between the words and xOffset (takes readDir into account)

	for i=1,#words do
		
		print( words[i].name )
		wordsTable[i] = display.newText( {text=words[i].name, font=font, fontSize=fontSize} ) -- create text display object
		wordsTable[i]:setFillColor( fontColor )
		wordsTable[i].alpha = 1
		wordsTable[i].activeText = display.newText( { text=words[i].name, font=font, fontSize=fontSize } ) -- create highlighted text display object
		wordsTable[i].activeText:setFillColor( fontColorHi )
		wordsTable[i].activeText.alpha = 0 -- hide the highlighted text object
		group:insert( wordsTable[i] ) -- insert into display group
		group:insert( wordsTable[i].activeText ) -- insert into display group

		if readDir == "leftToRight" then
			wordsTable[i].anchorX = 0
			wordsTable[i].anchorY = 0
			newX = x+xOffset -- offset to the left
		else -- rightToLeft reading direction
			wordsTable[i].anchorX = 1
			wordsTable[i].anchorY = 0
			newX = x-xOffset -- offset to the right
		end -- end if statement

		wordsTable[i].x = newX
		wordsTable[i].y = y
		wordsTable[i].activeText.x = newX
		wordsTable[i].activeText.y = y

		if ( canTapWords ) then
			name = string.lower( string.gsub( words[i].name, "['.,]", "" ) )
			wordsTable[i].wordAudio = audio.loadSound( wordAudioDir .. name .. ".mp3" )
			wordsTable[i].id = i
			wordsTable[i].durration = audio.getDuration( wordsTable[i].wordAudio ) -- length the word takes to play
			wordsTable[i]:addEventListener( "tap", SayWord )
		end -- end if canTapWords

		xOffset = xOffset + wordsTable[i].width + wordSpacing

		if ( words[i].newline ) then
			y = y + lineSpacing
			xOffset = 0
		end -- end if words[i].newline

	end -- end for i=1,#words

	words.soundLength = words[#words].out

	return wordsTable

end -- end of DisplayText


function M.AddSentence( params ) -- public function for adding the audio and text to be used
	print( "step 1 - import text and audio to be used" )

	local dataObject = {} -- will be used to store variables to be returned by the M.addSentence function

	local txtDisplayGroup = display.newGroup() -- display group for holding elements created in M.addSentence
    local fadeDuration = params.fadeDuration or 1000
    
    -- TODO: Rethink how the talkButton is being used
    -- Currently being used to also hold params table for other things
    -- Change those var to be in some kind of actual params table and make the button optional for those who want a talking icon?
    local channel = params.channel or 16 -- channel to play the narration audio (channels between 1 and 32)
    local delay = params.delay or 0 -- delay befor the narration starts playing and text is highlighted (value in milliseconds)
    local volume = params.volume or 1 -- volume level for the narration audio (values between 0 and 1)
    local font = params.font or native.systemFont -- text font
    local fontColor = params.fontColor or { 0, 0, 0 } -- font color for text(default is black)
    local fontColorHi = params.fontColorHi or { 0, 0, 1 } -- font color for highlighted text (default is blue)
    local fontSize = params.fontSize or 24 -- font size for text
    local padding = params.padding or 20 -- padding between words and edge of screen
    local lineOffset = params.lineOffset or 0 -- offset distance between lines of text
    local background = params.background or false -- include a rectangle background behind the text
    local backgroundAlpha = params.backgroundAlpha or 0 -- transparency of the background rectangle
    local backgroundColor = params.backgroundColor or { 1, 1, 1 } -- default color is white
    local readDir = params.readDir or "leftToRight" -- direction to read the text (supports "leftToRight" and "rightToLeft")
    local canTapWords = params.canTapWords or false -- make each word tappable and plan audio text of each word
    local includeTalkButton = params.includeTalkButton or false     -- include the talk button icon adjacent to the text
    local talkButton = params.talkButton or nil -- icon to indicate that narration audio is playing

    local talkButtonPadding -- padding to include the talkButton icon (if needed)
    if ( includeTalkButton ) then
    	talkButtonPadding = talkButton.width
    	talkButton:addEventListener( "tap", onTapSentence )
    else
    	talkButtonPadding = 0 -- no talkButton
    end

    dataObject.audio = params.audioFile -- file for the audio of the narration
    dataObject.words = params.words -- list of words and word timings
    dataObject.audioDir = params.audioDir -- directory of the audio file

    -- display the text and add the display group of text to the dataObject to be returned
    dataObject.displayTextTable = DisplayText(
	    {
	    	words=dataObject.words,
	    	audio=dataObject.audio,
	    	audioDir=dataObject.audioDir,
	    	x=params.x+padding+talkButtonPadding,
	    	y=params.y+padding+lineOffset,
	    	font=font,
	    	fontColor=fontColor,
	    	fontSize=fontSize,
	    	fontColorHi=fontColorHi,
	    	group=txtDisplayGroup,
	    	canTapWords=canTapWords,
	    	readDir=readDir
	    })

    -- create the background rectangle behind the text
    if ( background ) then
    	local backgroundRect = display.newRoundedRect( params.x, params.y, txtDisplayGroup.width + (padding * 2) + talkButtonPadding, txtDisplayGroup.height + (padding * 2), 12 )
    	backgroundRect:setFillColor( backgroundColor )
    	backgroundRect.alpha = backgroundAlpha
    	txtDisplayGroup:insert( 1, backgroundRect )
    end
    -- add in the talk button icon
    if ( includeTalkButton ) then
    	txtDisplayGroup:insert( talkButton )
    	talkButton.x = params.x + 10
    	talkButton.y = params.y + (backgroundRect.height / 2)
    end

    txtDisplayGroup.alpha = 0
    transition.to( txtDisplayGroup, { time=fadeDuration, alpha=1 } ) -- fade the text into view

    return dataObject, txtDisplayGroup

end -- end of M.AddSentence

return M -- return module table