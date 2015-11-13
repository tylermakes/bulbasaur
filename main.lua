-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
require("bulb_game_settings")
require("bulb_builder_settings")
require("saving_container")

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

bulbGameSettings = BulbGameSettings()
bulbBuilderSettings = BulbBuilderSettings()
savingContainer = SavingContainer(bulbGameSettings)	--param must have :getGameData and :setupFromData

savingContainer:load()

local storyboard = require "storyboard"
-- storyboard.gotoScene( "bulb_game_scene" )
storyboard.gotoScene( "bulb_builder_scene" )