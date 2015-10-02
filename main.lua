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
storyboard.gotoScene( "bulbasaur_game_scene" )