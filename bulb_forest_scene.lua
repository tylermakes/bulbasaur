require("bulb_forest")

-----------------------------------------------------------------------------------------
--
-- bulbasaur_builder_scene.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local game

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	if (not event.params) then
		event.params = {}
	end
	if (not game) then
		game = BulbForest(display.contentWidth, display.contentHeight, storyboard, event.params.mapFileName)
		game:create(group)
	end
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	if (not event.params) then
		event.params = {}
	end
	if (not game) then
		game = BulbForest(display.contentWidth, display.contentHeight, storyboard, event.params.mapFileName)
		game:create(group)
	end
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

	if (game) then
		game:removeSelf()
		game = nil
	end
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view

	if (game) then
		game:removeSelf()
		game = nil
	end
end

-----------------------------------------------------------------------------------------
scene:addEventListener( "createScene", scene ) -- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "enterScene", scene ) -- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "exitScene", scene ) -- "exitScene" event is dispatched whenever before next scene's transition begins
-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )
-----------------------------------------------------------------------------------------

return scene