require("class")
require("bulb_color")
require("bulb_player_data")
require("basic_init_file")
require("bulb_map_generator")

BulbGameSettings = class(function(c)
	c.mapNames = {}
	c.generatedMapData = {}
	c.temporaryMaps = {}
	-- generated map {filename="generated + mapNum", mapNum=1, location={1,1}}
	c.currentMapNum = 1
	c.playerData = BulbPlayerData()
	c.inGame = false

	c.TOTAL_SAVED_MAPS = 8

	c.rows = 15
	c.size = display.contentHeight/c.rows
	c.mapWidth = display.contentWidth/5*4
	c.columns = math.floor(c.mapWidth/c.size)

	local currentSaveFile = 1

	local saveFiles = {}
	saveFiles[1] = {empty=true}
	saveFiles[2] = {empty=true}
	saveFiles[3] = {empty=true}
	c.saveFiles = saveFiles

	local types = {}
	types["strawberry"] = { id=1, tileName="strawberry", harvestTime=60, cost=1001, color=BulbColor(1,0,0), artStates={2,3,4,5} }
	types["orange"] = { id=2, tileName="orange", harvestTime=30, cost=1002, color=BulbColor(1,0.6,0) }
	types["avocado"] = { id=3, tileName="avocado", harvestTime=20, cost=1003, color=BulbColor(0,0.6,0) }
	types["blueberries"] = { id=4, tileName="blueberries", harvestTime=50, cost=1004, color=BulbColor(0,0,1), artStates={2,3,4,6} }
	types["lemon"] = { id=5, tileName="lemon", harvestTime=120, cost=1005, color=BulbColor(1,1,0.6) }
	types["carrots"] = { id=6, tileName="carrots", harvestTime=90, cost=1007, color=BulbColor(1,0.8,0) }
	types["beets"] = { id=7, tileName="beets", harvestTime=75, cost=10010, color=BulbColor(0.8,0,.5) }
	types["peas"] = { id=8, tileName="peas", harvestTime=100, cost=1009, color=BulbColor(0,0.8,0) }
	types["pineapple"] = { id=9, tileName="pineapple", harvestTime=110, cost=1006, color=BulbColor(1,1,0) }
	types["asparagus"] = { id=10, tileName="asparagus", harvestTime=105, cost=1008, color=BulbColor(0.3,0.6,0.3) }
	c.types = types


	local grandmaSays = {}
	-- grandmaSays[1] = "I remember maybe 5 years ago I emailed a M.I.T. professor after seeing her on a PBS special talking about AI. I poured my brain into an email to her about my theories on AI development, how machines can be programmed to recognize environments, how emotions can be learned through experience,etc. I spent a good 4 hours writing the email because I felt a connection to this professor’s work. It was an exciting email to write because it was something I was very interested in and I wanted to reach out and talk to someone about it. There was so much hope while I was writing it that maybe I would get a response back and I would have someone to talk to about this kind of stuff, maybe get me started on the path to creating advanced machine AI. Sadly, I never heard back from her…I don’t even know if she read the email."
	grandmaSays[1] = "Hello"
	grandmaSays[2] = "Did you eat your vegetables?"
	grandmaSays[3] = "Have you seen my dentures?"
	grandmaSays[4] = "Okay, go away"

	local brotherSays = {}
	brotherSays[1] = "Hey..."
	brotherSays[2] = "I don't feel so well."
	brotherSays[3] = "I'm hungry."
	brotherSays[4] = "Do we have any food?"

	local talking = {}
	talking["grandma"] = grandmaSays
	talking["brother"] = brotherSays
	
	c.talking = talking


	local grandmaSaysDead = {}
	-- grandmaSays[1] = "I remember maybe 5 years ago I emailed a M.I.T. professor after seeing her on a PBS special talking about AI. I poured my brain into an email to her about my theories on AI development, how machines can be programmed to recognize environments, how emotions can be learned through experience,etc. I spent a good 4 hours writing the email because I felt a connection to this professor’s work. It was an exciting email to write because it was something I was very interested in and I wanted to reach out and talk to someone about it. There was so much hope while I was writing it that maybe I would get a response back and I would have someone to talk to about this kind of stuff, maybe get me started on the path to creating advanced machine AI. Sadly, I never heard back from her…I don’t even know if she read the email."
	grandmaSaysDead[1] = "Oh thank the heavens! You're awake!"
	grandmaSaysDead[2] = "I told you not to go out into the forest!"
	grandmaSaysDead[3] = "What happened?"
	grandmaSaysDead[4] = "Are you okay?"

	local brotherSaysDead = {}
	brotherSaysDead[1] = "I was so scared..."
	brotherSaysDead[2] = "Someone brought you back to us."
	brotherSaysDead[3] = "Someone or something..."
	brotherSaysDead[4] = "It was dark and scary. Don't go out into the woods anymore. Please!"

	local talkingDead = {}
	talkingDead["grandma"] = grandmaSaysDead
	talkingDead["brother"] = brotherSaysDead
	
	c.talkingDead = talkingDead

	-- c.forestStartName = "init";
	-- c.forestCurrentMap = "init";
	c.gardenFileName = "garden_data";
end)

function BulbGameSettings:getGardenFileName( )
	return self.gardenFileName..self.currentSaveFile
end

function BulbGameSettings:getGameData()
	return {
		mapNames = self.mapNames,
		saveFiles = self.saveFiles,
		currentSaveFile = self.currentSaveFile,
		inGame = self.inGame
	}
end

function BulbGameSettings:setupFromData(mainData)
	self.mapNames = mainData.mapNames
	self.saveFiles = mainData.saveFiles
	self.currentSaveFile = mainData.currentSaveFile
	self.inGame = mainData.inGame
	self.generatedMapData = mainData.generatedMapData

	if (#mainData.mapNames <= 0) then
		bulbGameSettings:addMapName("init")
		basicInitData.fileName = "init"
		savingContainer:saveFile(basicInitData, "init")
	end
end

function BulbGameSettings:saveGame( )
	if (globalBuildMode) then
		-- do not try to save game when testing a forest map
		return
	end
	local currentSave = self.saveFiles[self.currentSaveFile]
	savingContainer:saveFile({
			playerData = self.playerData:getGameData(),
			generatedMapData = self.generatedMapData,
			currentMapNum = self.currentMapNum
		}, "save_data"..self.currentSaveFile)
end

function BulbGameSettings:loadGame( idx )
	self.currentSaveFile = idx
	local loadedData = savingContainer:loadFile("save_data"..idx)
	self.playerData:setupFromGameData(loadedData.playerData)
	self.generatedMapData = loadedData.generatedMapData
	self.currentMapNum = loadedData.currentMapNum
end

function BulbGameSettings:getOpenSave( )
	for i=1, #self.saveFiles do
		if (self.saveFiles[i].empty) then
			return i
		end
	end

	return 0	-- no empty save file
end

function BulbGameSettings:isValidSave( idx )
	return self.saveFiles[idx] and not self.saveFiles[idx].empty
end

function BulbGameSettings:goToCurrentLocation( composer )
	if (bulbGameSettings.playerData.currentLocation == "garden") then
		composer.gotoScene( "bulb_game_scene" )
	elseif (bulbGameSettings.playerData.currentLocation == "home") then
		composer.gotoScene( "bulb_home_scene" )
	elseif (bulbGameSettings.playerData.currentLocation == "shop") then
		composer.gotoScene( "bulb_shop_scene" )
	-- elseif (bulbGameSettings.playerData.currentLocation == "forest") then
		-- local options =
		-- {
		-- 	effect = "fade",
		-- 	time = 500,
		-- 	params =
		-- 	{
		-- 		previousMapName = self.buildingMapName,
		-- 		//NOLONGERWORKSmapFileName = bulbGameSettings:getFileNameByMetaLocation(metaLocation),
		-- 		navLoc = {x = event.location.i, y = event.location.j},
		-- 		metaLoc = {event.metaLocation}
		-- 	}
		-- }
		-- composer.gotoScene( "bulb_forest_scene" )
	else
		composer.gotoScene( "bulb_game_scene" )
	end
end

function BulbGameSettings:addMapName(name)
	print("adding", name)
	local overwriting = false
	for i=1, #self.mapNames do
		if (self.mapNames[i] == name) then
			overwriting = true
		end
	end
	print("overwriting:", name)
	if (not overwriting) then
	print("adding:", #self.mapNames + 1, name)
		self.mapNames[#self.mapNames + 1] = name
	end
	savingContainer:save()
end

function BulbGameSettings:resetGeneratedMap(forestNav, location)
	print("reset?")
	self.currentMapNum = 0
	self.generatedMapData = {}
	self.temporaryMaps = {}
	self:generateMap(1, 1, 1, {x = forestNav.i, y = forestNav.j, name = location})
end

function BulbGameSettings:mapNumToName(num)
	return "generated_map"..num
end

function BulbGameSettings:generateMap(currentMapNum, x, y, previousLocation)
	local map = BulbMapGenerator:generateMap(self.rows, self.columns,
		self.size, previousLocation, {x=x, y=y})
	-- local mapData = {
						-- filename=self:mapNumToName(currentMapNum),
						-- mapNum=currentMapNum,
					-- 	location={x, y}
					-- }
	-- map.mapName = mapData.filename
	self.temporaryMaps[x..","..y] = map
end

function BulbGameSettings:hasNavTo(map, x, y)
	for i=1, #map.layers[1] do
		for j=1, #map.layers[1][i] do
			local tile = map.layers[1][i][j]
			local customData = tile.customData
			if (tile.tileName == "nav") then
				if (customData.metaLocation.x == x and
					customData.metaLocation.y == y) then
					return true -- HAS NAV TO OTHER LOCATION
				end
			end
		end
	end
	return false -- DOES NOT HAVE NAV TO OTHER LOCATION
end

-- function BulbGameSettings:generateMapIfNeedBe( x, y, tileX, tileY, mapName )
-- 	if (self.temporaryMaps[x..","..y] or self.generatedMapData[x..","..y]) then
-- 		return
-- 	end

-- 	self:generateMap(self.currentMapNum, x, y,
-- 		{x=tileX, y=tileY, name=mapName})
-- end

function BulbGameSettings:deleteOldMapAndGetCurrentMapNum()
	if (self.currentMapNum < self.TOTAL_SAVED_MAPS) then
		self.currentMapNum = self.currentMapNum + 1
	else
		self.currentMapNum = 1
	end
	print("current map num:"..self.currentMapNum)

	local delete = nil
	for k, v in pairs(self.generatedMapData) do
		if (v.mapNum == self.currentMapNum) then
			delete = k
		end
	end
	if (delete) then
		self.generatedMapData[delete] = nil
		self.temporaryMaps[delete] = nil
		print("deleting:"..delete)
	end
	return self.currentMapNum
end

function BulbGameSettings:generateAndSaveMap( x, y, tileX, tileY, mapName )
	self:generateMap(self.currentMapNum, x, y,
			{x=tileX, y=tileY, name=mapName})
	local mapNum = self:deleteOldMapAndGetCurrentMapNum()
	local mapData = {
						filename=self:mapNumToName(mapNum),
						mapNum=mapNum,
						location={x, y}
					}
	self.temporaryMaps[x..","..y].mapName = mapData.filename
	self.generatedMapData[x..","..y] = mapData
	bulbGameSettings:saveGame()
	savingContainer:saveFile(self.temporaryMaps[x..","..y], mapData.filename)
end

function BulbGameSettings:getTemporaryMap(x, y)
	return self.temporaryMaps[x..","..y]
end

function BulbGameSettings:clearTemporaryMaps( )
	self.temporaryMaps = {}
end

function BulbGameSettings:getMapDataAndSaveIfTemp(x, y, tileX, tileY, mapName)
	print("===entering:"..x..","..y)
	local returnData = {failure = "Couldn't find map."}
	local mapData = self.temporaryMaps[x..","..y]
	local mapFile = self.generatedMapData[x..","..y]
	local mapStatus = "mapStatus:"..x..","..y..":"
	print(mapData)
	if (mapData) then
		mapStatus = mapStatus.." was temp"
		returnData = self.temporaryMaps[x..","..y]
	elseif (mapFile) then
		mapStatus = mapStatus.." was gen"
		local loadedData = savingContainer:loadFile(mapFile.filename)
		if (loadedData.failure) then
			print("FAILED TO LOAD DATA FROM:", mapName)	-- probably filename doesn't exist
		else
			self.temporaryMaps[x..","..y] = loadedData
			returnData = loadedData
		end
	else
		self:generateAndSaveMap(x, y, tileX, tileY, mapName)
		returnData = self.temporaryMaps[x..","..y]
	end

	-- TODO: REMOVE
	-- PRINT MAP STATUS
	print(mapStatus)
	local totalTemps = 0
	local keysLine = ""
	for k,v in pairs(self.temporaryMaps) do
		totalTemps = totalTemps + 1
		keysLine = keysLine.."  "..k
		if (totalTemps % 5 == 0) then
			print(keysLine)
			keysLine = ""
		end
	end
	print(keysLine)
	print("\ttemps:"..totalTemps)

	local totalGens = 0
	keysLine = ""
	for k,v in pairs(self.generatedMapData) do
		totalGens = totalGens + 1
		keysLine = keysLine.."  "..k
		if (totalGens % 5 == 0) then
			print(keysLine)
			keysLine = ""
		end
	end
	print(keysLine)
	print("\tgen:"..totalGens)
	-- //PRINT MAP STATUS

	return returnData
end

function BulbGameSettings:getItemByID(id)
	for k, v in pairs(self.types) do
		if (v.id == id) then
			return v
		end
	end
end

function BulbGameSettings:getItemByName(name)
	return self.types[name]
end

function BulbGameSettings:getTextByName(name, isDead)
	if (isDead) then
		return self.talkingDead[name]
	end
	return self.talking[name]
end