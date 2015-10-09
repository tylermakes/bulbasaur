require("bulb_game")

-----------------------------------------------------------------------------------------
--
-- bulbasaur_game_scene.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
-- local character = nil;
-- local destination = nil;
-- local i = 30;
-- local moveSpeed = 100;

local game

-- local function onEnterFrame()
-- 	if (i <= 0) then
-- 		if (character.x < destination.x) then
-- 			character.x = character.x + moveSpeed;
-- 		end
-- 		if (character.x > destination.x) then
-- 			character.x = character.x - moveSpeed;
-- 		end
-- 		if (character.y < destination.y) then
-- 			character.y = character.y + moveSpeed;
-- 		end
-- 		if (character.y > destination.y) then
-- 			character.y = character.y - moveSpeed;
-- 		end
-- 		print("character:", character.x, ":", character.y)
-- 		print("destination:", destination.x, ":", destination.y)
-- 		i = 1
-- 	else
-- 		i = i - 1
-- 	end
-- end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	local game = BulbGame(display.contentWidth, display.contentHeight)
	game:create(group)
	
	-- local background = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	-- background:setFillColor( 1 )
	-- background.anchorX = 0;
	-- background.anchorY = 0;

	-- character = display.newRect( 0, 0, 40, 40 )
	-- character:setFillColor( 0.5, 0.8, 0.5 )
	-- character.anchorX = 0;
	-- character.anchorY = 0;
	-- destination = display.newRect( 0, 0, 10, 10 )
	-- destination:setFillColor( 0.8, 0.5, 0.5 )
	-- destination.anchorX = 0;
	-- destination.anchorY = 0;

	-- group:insert(background);
	-- group:insert(character);

	-- local function moveBlock(event)
	-- 	if ( event.phase == "began" ) then
	-- 		destination.x = event.x;
	-- 		destination.y = event.y;
	-- 		print("D:", destination.x, ":", destination.y)
	-- 	end
	-- 	return true
	-- end

	-- Runtime:addEventListener("enterFrame", onEnterFrame)
	-- group:addEventListener("touch", moveBlock)
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view

	if (game) then
		game:removeSelf()
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