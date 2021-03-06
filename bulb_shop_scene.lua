require("bulb_shop")

-----------------------------------------------------------------------------------------
--
-- bulbasaur_Shop_scene.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local game

-- Called when the scene's view does not exist:
function scene:create( event )
	local group = self.view
	if (not event.params) then
		event.params = {}
	end
	game = BulbShop(display.contentWidth, display.contentHeight, composer)
	game:create(group, event.params)
end

-- Called immediately after scene has moved onscreen:
function scene:show( event )
	local group = self.view
	if (not event.params) then
		event.params = {}
	end
	if (game) then
		game:entered(group, event.params)
	end
end

-- Called when scene is about to move offscreen:
function scene:hide( event )
	local group = self.view
	if (game) then
		game:left(group)
	end
end

-- If scene's view is removed, scene:destroy() will be called just prior to:
function scene:destroy( event )
	local group = self.view

	if (game) then
		game:removeSelf()
		game = nil
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