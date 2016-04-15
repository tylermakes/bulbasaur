require("class")
require("rpg_text")

BulbLivingRoom = class(function(c, width, height)
	c.width = width
	c.height = height
	c.characters = {}
	c.background = nil
	c.rpgTextBox = nil
	c.isDead = false
	c.events = {}
end)

function BulbLivingRoom:create(group, isDead)
	self.isDead = isDead
	self:addCharacter(group, "grandma", 30, 75, 150, 260)
	self:addCharacter(group, "brother", 670, 55, 100, 235)
	self:addCharacter(group, "exit", 315, 45, 150, 270)

	local background = display.newImageRect("assets/homebackground.png", self.width, self.height)
	background.anchorX = 0;
	background.anchorY = 0;
	background.x = 0;
	background.y = 0;
	self.background = background

	-- ADD TEXT OBJECT FOR RPG TEXT BOX
	local textOptions = {
		text = "TESTING!",
		x = 0,
		y = 0,
		width = 750,
		height = 260,
		font = native.systemFont,
		fontSize = 36, 
		align = "left"
	}
	local textObj = display.newText( textOptions )
	textObj:setFillColor(1, 0, 0)
	textObj.anchorX = 0
	textObj.anchorY = 0
	textObj.x = 40
	textObj.y = 520

	-- ADD BUTTON FOR CONTINUING RPG TEXT
	local skipButton = display.newCircle(0, 0, 25)
	skipButton:setFillColor(0, 1, 0)
	skipButton.x = 750
	skipButton.y = 700

	local rpgTextBox = RPGText(textObj, skipButton)
	self.rpgTextBox = rpgTextBox

	group:insert(self.background)	
	group:insert(textObj)
	group:insert(skipButton)
end

function BulbLivingRoom:entered(isDead)
	self.isDead = isDead
end

function BulbLivingRoom:update()
	self.rpgTextBox:update()
end

function BulbLivingRoom:addCharacter(group, name, x, y, width, height)
	local character = {}
	character.name = name
	character.x = x
	character.y = y
	character.width = width
	character.height = height

	local livingRoom = self

	function character:touch(event)
		if ( event.phase == "began" ) then
			if (self.name == "exit") then
				locationEvent = {
					name = "navigate"
				}
				livingRoom:dispatchEvent(locationEvent)
			else
				livingRoom:saySomething(self.name)
			end
		end
	end

	local clickRect = display.newRect(0, 0, width, height)
	clickRect:setFillColor(1, 0, 0)
	clickRect.isVisible = false
	clickRect.isHitTestable = true
	clickRect.anchorX = 0
	clickRect.anchorY = 0
	clickRect.x = x
	clickRect.y = y
	group:insert(clickRect)

	clickRect:addEventListener("touch", character)
	
	character.clickRect = clickRect

	self.characters[#self.characters + 1] = character
end

function BulbLivingRoom:saySomething(name)
	self.rpgTextBox:say(bulbGameSettings:getTextByName(name, self.isDead))
end

function BulbLivingRoom:addEventListener(type, object)
	if (not self.events[type]) then
		self.events[type] = {}
	end
	self.events[type][#self.events[type] + 1] = object
end

function BulbLivingRoom:dispatchEvent(data)
	if (self.events[data.name]) then
		for i=1, #self.events[data.name] do
			self.events[data.name][i][data.name](self.events[data.name][i], data)
		end
	end
end

function BulbLivingRoom:removeSelf( )
	if (self.background) then
		self.background:removeSelf()
		self.background = nil
	end
	for i=1, #self.characters do
		self.characters[i].clickRect:removeEventListener("touch", self.characters[i])
		self.characters[i].clickRect:removeSelf()
		self.characters[i].clickRect = nil
		self.characters[i] = nil
	end
	self.characters = nil
	if (self.rpgTextBox) then
		self.rpgTextBox:removeSelf()
		self.rpgTextBox = nil
	end

	for k, v in pairs(self.events) do
		for i=1, #v do
			self.events[k][i] = nil
		end
		self.events[k] = nil
	end
	self.events = nil
	self.events = {}
end