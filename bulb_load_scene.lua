-----------------------------------------------------------------------------------------
--
-- bulb_menu_scene.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

local background
local playBtns
local cancelButton
local overwriteText
local isOverwritingSave

local function onSelectedSave(event)
	if (isOverwritingSave) then	-- no open save file
		bulbGameSettings.currentSaveFile = event.target.selectedIndex
		composer.gotoScene( "bulb_save_name_scene", "fade", 500 )
	else
		if (bulbGameSettings:isValidSave(event.target.selectedIndex)) then
			bulbGameSettings:loadGame(event.target.selectedIndex)
			bulbGameSettings.inGame = true
			savingContainer:save()
			bulbGameSettings:goToCurrentLocation(composer)
		else
			-- they're trying to load an empty file
			print(event.target.selectedIndex.." is not a valid save file")
		end
	end

	return true
end

local function onCancelReleased()
	composer.gotoScene( "bulb_menu_scene", "fade", 500 )

	return true
end

local function makePlayButton(i, y, group)
	-- create a widget button (which will loads level1.lua on release)
	local playBtn = widget.newButton{
		label=bulbGameSettings.saveFiles[i].name or "Empty",
		labelColor = { default={255}, over={128} },
		fontSize = 48,
		defaultFile="button.png",
		overFile="button-over.png",
		width=300, height=80,
		onRelease = onSelectedSave	-- event listener function
	}
	playBtn.selectedIndex = i
	playBtn.x = display.contentWidth*0.5
	playBtn.y = y
	playBtns[i] = playBtn
	group:insert(playBtn)
end

-- Called when the scene's view does not exist:
function scene:create( event )
	local group = self.view

	background = display.newImageRect( "background.jpg", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0
	background.y = 0
	
	-- create a widget button (which will loads level1.lua on release)
	cancelButton = widget.newButton{
		label="Cancel",
		labelColor = { default={255}, over={128} },
		fontSize = 48,
		defaultFile="button.png",
		overFile="button-over.png",
		width=300, height=80,
		onRelease = onCancelReleased	-- event listener function
	}
	cancelButton.x = display.contentWidth*0.5
	cancelButton.y = display.contentHeight - 125
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( cancelButton )

	playBtns = {}
	makePlayButton(1, display.contentHeight - 525, group)
	makePlayButton(2, display.contentHeight - 425, group)
	makePlayButton(3, display.contentHeight - 325, group)
end

-- Called immediately after scene has moved onscreen:
function scene:show( event )
	local group = self.view

	if (event.phase == "will") then
		if (not overwriteText and event.params and event.params.overwrite) then
		isOverwritingSave = true
		local options = {
			x = display.contentWidth/2,
			y = display.contentHeight - 625,
			width = display.contentWidth - 20,
			height = 50,
			text = "Save Files Full. Select One To Override or Cancel"
		}
		overwriteText = display.newText( options )
		group:insert( overwriteText )
		else
			isOverwritingSave = false
		end

		-- update labels for newly created saves
		playBtns[1]:setLabel(bulbGameSettings.saveFiles[1].name or "Empty")
		playBtns[2]:setLabel(bulbGameSettings.saveFiles[2].name or "Empty")
		playBtns[3]:setLabel(bulbGameSettings.saveFiles[3].name or "Empty")
	end
end

-- Called when scene is about to move offscreen:
function scene:hide( event )
	local group = self.view

	if overwriteText then
		overwriteText:removeSelf()
		overwriteText = nil
	end
end

-- If scene's view is removed, scene:destroy() will be called just prior to:
function scene:destroy( event )
	local group = self.view

	if background then
		background:removeSelf()
		background = nil
	end
	for i=1, #playBtns do
		playBtns[i]:removeSelf()
		playBtns[i] = nil 
	end
	if cancelButton then
		cancelButton:removeSelf()
		cancelButton = nil
	end
	if overwriteText then
		overwriteText:removeSelf()
		overwriteText = nil
	end
end

-----------------------------------------------------------------------------------------
scene:addEventListener( "create", scene ) -- "create" event is dispatched if scene's view does not exist
scene:addEventListener( "show", scene ) -- "show" event is dispatched whenever scene transition has finished
scene:addEventListener( "hide", scene ) -- "hide" event is dispatched whenever before next scene's transition begins
-- "destroy" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- composer.purgeScene() or composer.removeScene().
scene:addEventListener( "destroy", scene )
-----------------------------------------------------------------------------------------

return scene