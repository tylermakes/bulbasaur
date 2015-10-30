require("class")

SavingContainer = class(function(c)
	c.json = require("json")
	local defaultGameData = {}
	defaultGameData["mapNames"] = {}
	c.gameData = defaultGameData
end)

function SavingContainer:save()
	print("SAVING?")
	local currentGameData = {}

	local encodedData = self.json.encode(currentGameData)
	-- print('Saving this: ' .. encodedData)

	local path = system.pathForFile( "gamedata.txt", system.DocumentsDirectory )

	-- io.open opens a file at path. returns nil if no file found
	local fh = io.open( path, "w" )

	if (fh) then
		fh:write( encodedData )
	end

	io.close( fh )
end

function SavingContainer:load()
	-- load
	local path = system.pathForFile( "gamedata.txt", system.DocumentsDirectory )

	-- io.open opens a file at path. returns nil if no file found
	local fh, reason = io.open( path, "r" )
	local contents

	if fh then
		-- read all contents of file into a string
		contents = fh:read( "*a" )
	else
	--	print( "Reason open failed: " .. reason )  -- display failure message in terminal

		if (string.find(reason, "No such file or directory")) then

			contents = self.json.encode(self.gameData)

			-- create file because it doesn't exist yet
			fh = io.open( path, "w" )

			if (fh) then
				fh:write( contents ) -- write data here
			end
		end
	end
	if (fh) then
		io.close( fh )
	end
	self.gameData = self.json.decode(contents)
end

function SavingContainer:saveFile(data, fileName, directory)
	print("SAVING FILE?")
	if ( not directory ) then
		directory = system.DocumentsDirectory
	end

	-- load
	local path = system.pathForFile( fileName, directory )
	local failure = false

	local encodedData = self.json.encode(data)
	-- print('Saving this: ' .. encodedData)

	local path = system.pathForFile( fileName, directory )

	-- io.open opens a file at path. returns nil if no file found
	local fh = io.open( path, "w" )

	if (fh) then
		fh:write( encodedData )
	end

	io.close( fh )
end

function SavingContainer:loadFile(fileName, directory)
	if ( not directory ) then
		directory = system.DocumentsDirectory
	end

	-- load
	local path = system.pathForFile( fileName, directory )
	local failure = false

	-- io.open opens a file at path. returns nil if no file found
	local fh, reason = io.open( path, "r" )
	local contents

	if fh then
		-- read all contents of file into a string
		contents = fh:read( "*a" )
	else
		failure = true
	end
	if (fh) then
		io.close( fh )
	end
	if (failure) then
		return { failure = true }
	else
		return self.json.decode(contents)
	end
end