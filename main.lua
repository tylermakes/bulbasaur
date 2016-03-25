-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
require("bulb_game_settings")
require("bulb_builder_settings")
require("saving_container")
require("bulb_astar")
require("tm_utilities")

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

bulbGameSettings = BulbGameSettings()
bulbBuilderSettings = BulbBuilderSettings()
savingContainer = SavingContainer(bulbGameSettings)	--param must have :getGameData and :setupFromData

globalAStar = BulbAStar()
savingContainer:load()

globalBuildMode = false

local composer = require( "composer" )
if (globalBuildMode) then
	composer.gotoScene( "bulb_builder_scene" )
else
	if (bulbGameSettings.inGame and not bulbGameSettings.saveFiles[bulbGameSettings.currentSaveFile].empty) then
		bulbGameSettings:loadGame(bulbGameSettings.currentSaveFile)
		bulbGameSettings:goToCurrentLocation(composer)
	else
		composer.gotoScene( "bulb_menu_scene" )
	end
end