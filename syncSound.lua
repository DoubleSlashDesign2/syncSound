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
-- version 4.0 - (5/14/14)  Rewrite Electric Eggplant's original code to current Corona SDK and LUA module implimentation standards.
--                          Added the ability to import audio and audio text files directly from audacity export files (no more hardcoding in the text).

local M = {} -- init module table


local function SayWord( event ) -- private function added as the listener function to each word if canTapWords is set to true
    print( event.target.name .. " was tapped" )
    local word = event.target

    local dur = (word.durration) + 100 -- durration the highlight lasts on each word

    if ( audio.isChannelPlaying( word.channel ) == false ) then -- if the audio channel is not already playing something
        transition.to(word, { x=word.x-3, y=word.y-10, time=100, alpha=1, xScale=1.1, yScale=1.1 } ) -- increase the size and position of the word
        transition.to(word.activeText, { x=word.activeText.x-3, y=word.activeText.y-10, time=100, alpha=1, xScale=1.1, yScale=1.1 } ) -- increase the size and position of the highlight word and turn on the highlight
        transition.to(word.activeText, { x=word.activeText.x, y=word.activeText.y, delay=dur, alpha=0, time=100, xScale=1, yScale=1 } ) -- reset the highlight word
        transition.to(word, { x=word.x, y=word.y, delay=dur, alpha=1, time=100, xScale=1, yScale=1  } ) -- reset the word
        audio.setVolume( word.volume ) -- set volume
        audio.play( word.wordAudio ) -- play the word's audio
    end -- end if ( audio.isChannelPlaying( word.channel ) == false )
end -- end SayWord function


function M.SaySentence( params )
    print( "step 3 - play the audio and highlight the text" )
    if ( params.narration ) then
        local wordsObject = params.wordsObject
        local textTable = wordsObject.displayTextTable
        local audioFile = wordsObject.audioFile
        local words = wordsObject.words
        local delayNarration = params.delayNarration or 500
        local delayStart
        local delayOut
        local fadeDuration = params.fadeDuration or 100
        local channel = params.channel or 16
        local volume = params.volume or 1

        if ( audio.isChannelPlaying( channel ) == false ) then
            local timerClosure = function()
                audio.rewind( audioFile )
                audio.setVolume( volume )
                audio.play( audioFile )

                if ( wordsObject.talkButton ~= nil) then -- if a talk icon is being included with the text
                    transition.to( wordsObject.talkButton, { time=fadeDuration, alpha=0.7 } )
                    transition.to( wordsObject.talkButton, { time=fadeDuration, delay=words.soundLength + fadeDuration, alpha=1 } )
                end

                for i=1,#words do
                    
                    delayStart = (words[i].start * 1000) - fadeDuration
                    if delayStart < 0 then delayStart = 0 end
                    delayOut = (words[i].out * 1000) + fadeDuration

                    transition.to( textTable[i].activeText, { delay = delayStart, alpha=1, time=fadeDuration } )
                    transition.to( textTable[i].activeText, { delay = delayOut, alpha=0, time=fadeDuration } )

                end -- end for i=1,#words
            end -- end timerClosure
            saySentenceTimer = timer.performWithDelay( delayNarration, timerClosure )
        end -- end if ( audio.isChannelPlaying( channel ) == false )
    end -- end if ( params.narration )
end -- end function M.saySentence


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
        wordsTable[i]:setFillColor( fontColor[1], fontColor[2], fontColor[3] )
		wordsTable[i].alpha = 1
		wordsTable[i].activeText = display.newText( { text=words[i].name, font=font, fontSize=fontSize } ) -- create highlighted text display object
		wordsTable[i].activeText:setFillColor( fontColorHi[1], fontColorHi[2], fontColorHi[3] )
		wordsTable[i].activeText.alpha = 0 -- hide the highlighted text object
		group:insert( wordsTable[i] ) -- insert into display group
		group:insert( wordsTable[i].activeText ) -- insert into display group

		if readDir == "leftToRight" then
			wordsTable[i].anchorX = 0
            wordsTable[i].activeText.anchorX = 0
			wordsTable[i].anchorY = 0
            wordsTable[i].activeText.anchorY = 0
			newX = x+xOffset -- offset to the left
		else -- rightToLeft reading direction
			wordsTable[i].anchorX = 1
            wordsTable[i].activeText.anchorX = 1
			wordsTable[i].anchorY = 0
            wordsTable[i].activeText.anchorY = 0
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
            wordsTable[i].name = name
            wordsTable[i].channel = params.channel
            wordsTable[i].volume = params.volume
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
    
    local channel = params.channel or 16 -- channel to play the narration audio (channels between 1 and 32)
    local volume = params.volume or 1 -- volume level for the narration audio (values between 0 and 1)
    local font = params.font or native.systemFont -- text font
    local fontColor = params.fontColor or {0, 0, 0} -- font color for text(default is black)
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

    dataObject.audioFile = params.audioFile -- file for the audio of the narration
    dataObject.audioDir = params.audioDir -- directory of the audio file

    local audacityFile = params.audacityFile or false -- let the user directly import an audacity label text file
    
    if ( audacityFile ) then -- if using an audacity label text file
    	print( "Audacity File Extraction:" )
    
    	local file = params.words -- audacity labels text file
    	local data = io.open( file, "r" ) -- open the file
    	dataObject.words = {} -- table to store the words and timings rows
	
		local i = 1
		for line in data:lines() do
		    dataObject.words[i] = {} -- table to store the words and timeings
		    dataObject.words[i].start, dataObject.words[i].out, dataObject.words[i].name = string.match( line, '(%S+)%s*(%S+)%s*(%S+)' ) -- extract the start/stop/word
		    print( dataObject.words[i].name )
		    i = i + 1 -- go to next line
		end -- end for line in data:lines()
    
    else -- not using an audacity label text file
    	dataObject.words = params.words -- list of words and word timings
    end -- end if audacityFile

    -- display the text and add the display group of text to the dataObject to be returned
    dataObject.displayTextTable = DisplayText(
	    {
	    	words=dataObject.words,
	    	audioFile=dataObject.audioFile,
	    	audioDir=dataObject.audioDir,
	    	x=params.x+padding+talkButtonPadding,
	    	y=params.y+padding+lineOffset,
	    	font=font,
	    	fontColor=fontColor,
	    	fontSize=fontSize,
	    	fontColorHi=fontColorHi,
	    	group=txtDisplayGroup,
	    	canTapWords=canTapWords,
            channel=channel,
            volume=volume,
	    	readDir=readDir
	    })

    -- create the background rectangle behind the text
    if ( background ) then
    	local backgroundRect = display.newRoundedRect( params.x, params.y, txtDisplayGroup.width + (padding * 2) + talkButtonPadding, txtDisplayGroup.height + (padding * 2), 12 )
    	backgroundRect:setFillColor( backgroundColor[1], backgroundColor[2], backgroundColor[3] )
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