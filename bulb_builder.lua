require("class")
require("bulb_builder_map")
require("bulb_builder_ui")
require("bulb_file_name_popup")

BulbBuilder = class(function(c, width, height, storyboard)
	c.width = width
	c.height = height
	c.map = nil
	c.player = nil
	c.ui = nil
	c.state = "nothing"
	c.selectedPlant = nil
	c.selectTool = nil
	c.filePopup = nil
	c.storyboard = storyboard
	c.fullDisplayGroup = nil
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

	local home = {tileName="home", color=BulbColor(0.8, 0.4, 1)}
	self.ui = BulbBuilderUI(home, mapWidth, 0, self.width/5, self.height, 10)
	self.ui:addEventListener("selectTile", self)
	self.ui:addEventListener("selectTool", self)
	self.ui:create(self.fullDisplayGroup)

	Runtime:addEventListener("enterFrame", self)
	group:insert(self.fullDisplayGroup)
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
	if (data.type == "home") then
		self.storyboard.gotoScene( "bulb_home_scene", "fade", 500 )
	elseif (data.type == "save") then
		if (not self.map.mapName) then
			self:clearFilePopup()
			self.filePopup = BulbFileNamePopup("Enter Save Name:")
			self.filePopup:create(self.fullDisplayGroup)
		end
	elseif (data.type == "load") then
		self:clearFilePopup()
		self.filePopup = BulbFileNamePopup("Enter Load Name:")
		self.filePopup:create(self.fullDisplayGroup)
	else
		self.state = "tooling"
		self.selectedTool = data.type
	end
end

function BulbBuilder:placeTile(event)
	if (self.state == "placing") then 
		self.map:placeTile(event.x, event.y, self.selectedTile)
	elseif (self.state == "tooling") then
	end
end

function BulbBuilder:clearFilePopup()
	if (self.filePopup) then
		self.filePopup:removeSelf()
		self.filePopup = nil
	end
end

function BulbBuilder:removeSelf()
	if (self.map) then
		self.map:removeSelf()
		self.map = nil
	end
	if (self.ui) then
		self.ui:removeSelf()
		self.ui = nil
	end
	if (self.fullDisplayGroup) then
		self.fullDisplayGroup:removeSelf()
		self.fullDisplayGroup = nil
	end
	if (self.filePopup) then
		self.filePopup:removeSelf()
		self.filePopup = nil
	end
end