require("class")
require("bulb_builder_map")
require("bulb_builder_ui")
require("bulb_file_name_popup")

BulbBuilder = class(function(c, width, height, composer)
	c.width = width
	c.height = height
	c.map = nil
	c.player = nil
	c.ui = nil
	c.state = "nothing"
	c.selectedPlant = nil
	c.selectTool = nil
	c.filePopup = nil
	c.composer = composer
	c.fullDisplayGroup = nil
	c.navTile = nil
end)

function BulbBuilder:create(group)
	self.fullDisplayGroup = display.newGroup()

	local rows = 15
	local size = self.height/rows
	local mapWidth = self.width/5*4
	local columns = math.floor(mapWidth/size)

	self.map = BulbBuilderMap(mapWidth, self.height, rows, columns)
	self.map:create(self.fullDisplayGroup)
	self.map:addEventListener("placeTile", self)

	Runtime:addEventListener("enterFrame", self)
	group:insert(self.fullDisplayGroup)

	-- load "init" map on startup
	local loadedData = savingContainer:loadFile("init")
	self.map:loadMapFromData(loadedData)
end

function BulbBuilder:entered(group)
	-- triggered when the scene is entered or re-entered
	-- savingContainer:save()
	if (not self.ui) then
		local mapWidth = self.width/5*4
		local tools = {}
		tools[1] = {tileName="main menu", color=BulbColor(0.8, 0.4, 1)}
		tools[2] = {tileName="save", color=BulbColor(0.6, 0.6, 0.4)}
		tools[3] = {tileName="load", color=BulbColor(0.6, 0.4, 0.6)}
		tools[4] = {tileName="clear", color=BulbColor(0.2, 0.4, 0.2)}
		tools[5] = {tileName="play", color=BulbColor(0.1, 0.5, 0.3)}
		self.ui = BulbBuilderUI(tools, mapWidth, 0, self.width/5, self.height, 10)
		self.ui:addEventListener("selectTile", self)
		self.ui:addEventListener("selectTool", self)
		self.ui:create(self.fullDisplayGroup)
	end
end

function BulbBuilder:left( )
	-- triggered when the scene is entered or re-entered
	-- savingContainer:save()
	if (self.ui) then
		self.ui:removeSelf()
		self.ui = nil
	end
end

function BulbBuilder:enterFrame()
	self:update()
end

function BulbBuilder:update()
	-- self.map:update()
end

function BulbBuilder:selectTile(data)
	self.state = "placing"
	self.selectedTile = data.item
end

function BulbBuilder:selectTool(data)
	if (data.type == "main menu") then
		globalBuildMode = false -- once you leave, you can't come back
		self.composer.gotoScene( "bulb_menu_scene", "fade", 500 )
	elseif (data.type == "save") then
		if (not self.map.mapName) then
			self:clearFilePopup()
			self.filePopup = BulbFileNamePopup("Enter Save Name:", "saving")
			self.filePopup:create(self.fullDisplayGroup)
			self.filePopup:addEventListener("fileName", self)
			self.filePopup:addEventListener("clearFilePopup", self)
		end
	elseif (data.type == "load") then
		self:clearFilePopup()
		self.filePopup = BulbFileNamePopup("Enter Load Name:", "loading")
		self.filePopup:create(self.fullDisplayGroup)
		self.filePopup:addEventListener("fileName", self)
		self.filePopup:addEventListener("clearFilePopup", self)
	elseif (data.type == "clear") then
		self.map:clear()
	elseif (data.type == "play") then
		local saveData = self:getSaveData()
		savingContainer:saveFile(saveData, "temp")

		local options =
		{
			effect = "fade",
			time = 500,
			params =
			{
				mapFileName = "temp"
			}
		}
		self.composer.gotoScene( "bulb_forest_scene", options )
	else
		print("unknown tool type:", data.type)
		-- self.state = "tooling"
		-- self.selectedTool = data.type
	end
end

function BulbBuilder:placeTile(event)
	if (self.state == "placing") then 
		if (self.selectedTile.tileName == "nav" and
			self.map:getTile({i=event.x, j=event.y}).tileInfo.tileName == "nav") then
			
			self.navTile = {i=event.x, j=event.y}
			self:clearFilePopup()
			self.filePopup = BulbFileNamePopup("Enter Nav Location:", "nav_location")
			self.filePopup:create(self.fullDisplayGroup)
			self.filePopup:addEventListener("fileName", self)
			self.filePopup:addEventListener("clearFilePopup", self)
		else
			self.map:placeTile(event.x, event.y, self.selectedTile, self.selectedTile.customData)
		end
	elseif (self.state == "tooling") then
	end
end

function BulbBuilder:getSaveData()
	local saveData = self.map:getSaveData()
	return saveData
end

-- called when a filename is selected from our filePopup dialog for saving or loading
function BulbBuilder:fileName(evt)
	if (evt.action == "saving") then
		bulbGameSettings:addMapName(evt.fileName)
		local saveData = self:getSaveData()
		saveData.fileName = evt.fileName
		savingContainer:saveFile(saveData, evt.fileName)
	elseif (evt.action == "loading") then
		local loadedData = savingContainer:loadFile(evt.fileName)
		if (loadedData.failure) then
			print("FAILED TO LOAD DATA FROM:", evt.fileName)	-- probably filename doesn't exist
		else
			self.map:loadMapFromData(loadedData)
		end
	elseif (evt.action == "nav_location") then
		self.map:setNavLocation(self.navTile, evt.fileName)
	else
		print("unknown action", evt.action, " on filename:", evt.fileName)
	end
	self:clearFilePopup();
end

function BulbBuilder:clearFilePopup()
	if (self.filePopup) then
		self.filePopup:removeSelf()
		self.filePopup = nil
	end
end

function BulbBuilder:removeMap()
	if (self.map) then
		self.map:removeSelf()
		self.map = nil
	end
end

function BulbBuilder:removeSelf()
	self:clearFilePopup()
	self:removeMap()
	if (self.ui) then
		self.ui:removeSelf()
		self.ui = nil
	end
	if (self.fullDisplayGroup) then
		self.fullDisplayGroup:removeSelf()
		self.fullDisplayGroup = nil
	end
	self.navTile = nil
end