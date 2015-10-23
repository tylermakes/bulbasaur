-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
require("bulb_game_settings")

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

bulbGameSettings = BulbGameSettings()

local storyboard = require "storyboard"
-- storyboard.gotoScene( "bulb_game_scene" )
storyboard.gotoScene( "bulb_home_scene" )