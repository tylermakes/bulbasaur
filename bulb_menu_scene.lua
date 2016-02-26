-----------------------------------------------------------------------------------------
--
-- bulb_menu_scene.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

local playBtn
local loadBtn
local background

local function onStartNewGame()
	openSaveFile = bulbGameSettings:getOpenSave()
	if (openSaveFile <= 0) then	-- no open save file
		local options =
		{
			effect = "fade",
			time = 500,
			params =
			{
				overwrite = true
			}
		}
		composer.gotoScene( "bulb_load_scene", options)
	else
		bulbGameSettings.currentSaveFile = openSaveFile
		composer.gotoScene( "bulb_save_name_scene", "fade", 500 )
	end

	return true
end

local function onLoadGame()
	composer.gotoScene( "bulb_load_scene", "fade", 500 )

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
		label="New Game",
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
	loadBtn = widget.newButton{
		label="Load Game",
		labelColor = { default={255}, over={128} },
		fontSize = 48,
		defaultFile="button.png",
		overFile="button-over.png",
		width=300, height=80,
		onRelease = onLoadGame	-- event listener function
	}
	loadBtn.x = display.contentWidth*0.5
	loadBtn.y = display.contentHeight - 125
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( playBtn )
	group:insert( loadBtn )
end

-- Called immediately after scene has moved onscreen:
function scene:show( event )
	local group = self.view

	-- clear out old data and mark that not in game
	bulbGameSettings.inGame = false
	composer.removeScene("bulb_game_scene")
	composer.removeScene("bulb_forest_scene")
	composer.removeScene("bulb_home_scene")
	savingContainer:save()
end

-- Called when scene is about to move offscreen:
function scene:hide( event )
	local group = self.view
end

-- If scene's view is removed, scene:destroy() will be called just prior to:
function scene:destroy( event )
	local group = self.view

	if background then
		background:removeSelf()
		background = nil
	end
	if playBtn then
		playBtn:removeSelf()
		playBtn = nil
	end
	if loadBtn then
		loadBtn:removeSelf()
		loadBtn = nil
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