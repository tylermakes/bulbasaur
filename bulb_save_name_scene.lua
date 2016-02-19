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
local playBtn
local cancelButton
local nameView

local function onStartNewGame()
	if (nameView and nameView.text ~= "") then
		bulbGameSettings.saveFiles[bulbGameSettings.currentSaveFile].name = nameView.text
		bulbGameSettings.saveFiles[bulbGameSettings.currentSaveFile].empty = false
		bulbGameSettings.playerData = BulbPlayerData()
		bulbGameSettings:saveGame()
		savingContainer:save()
		composer.gotoScene( "bulb_game_scene", "fade", 500 )
	else
		-- put in a valid name
	end

	return true
end

local function onCancelReleased()
	composer.gotoScene( "bulb_menu_scene", "fade", 500 )

	return true
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
	playBtn = widget.newButton{
		label="Start Game",
		labelColor = { default={255}, over={128} },
		fontSize = 48,
		defaultFile="button.png",
		overFile="button-over.png",
		width=300, height=80,
		onRelease = onStartNewGame	-- event listener function
	}
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 325
	
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
	group:insert( playBtn )
	group:insert( cancelButton )
end

-- Called immediately after scene has moved onscreen:
function scene:show( event )
	local group = self.view
	if not nameView then
		-- ADD NAME TEXT
		nameView = native.newTextField( 0, 0, display.contentWidth - 20, 50 )
		nameView.anchorX = 0;
		nameView.anchorY = 0;
		nameView.x = 10;
		nameView.y = display.contentHeight - 625;
		group:insert( nameView )
	end
end

-- Called when scene is about to move offscreen:
function scene:hide( event )
	local group = self.view
	if nameView then
		nameView:removeSelf()
		nameView = nil
	end
end

-- If scene's view is removed, scene:destroy() will be called just prior to:
function scene:destroy( event )
	local group = self.view

	if nameView then
		nameView:removeSelf()
		nameView = nil
	end
	if background then
		background:removeSelf()
		background = nil
	end
	if playBtn then
		playBtn:removeSelf()
		playBtn = nil
	end
	if cancelButton then
		cancelButton:removeSelf()
		cancelButton = nil
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