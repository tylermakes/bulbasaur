require("class")

RPGText = class(function(c, textObject, continueButton)
	c.CHARACTER_WAIT_MAX = 0
	c.textObject = textObject
	c.linesOfText = {}
	c.currentLine = 1
	c.currentText = ""
	c.characterWait = 0
	c.state = "idle"
	c.continueButton = continueButton
	c.continueButton:addEventListener("touch", c)
end)

function RPGText:say(linesOfText)
	-- IF PASSING "LINESOFTEXT" WE WANT TO START SAYING SOMETHING NEW
	if (linesOfText) then
		self.linesOfText = linesOfText
		self.currentLine = 1
		self:startSaying()
	elseif (self.state == "add_text") then
		self.textObject.text = self.currentText;
		self.characterWait = 0
	elseif (self.state == "idle") then
		if (self.currentLine < #self.linesOfText) then
			self.currentLine = self.currentLine + 1
			self:startSaying()
		end
	end
end

function RPGText:touch(event)
	if (event.phase == "began") then
		self:say()
	end
end

function RPGText:startSaying()
	self.currentText = self.linesOfText[self.currentLine]
	self.characterWait = 0
	self.textObject.text = ""
	self.state = "add_text"
end

function RPGText:update()
	if (self.state == "add_text") then
		if (self.characterWait == 0 and #self.textObject.text < #self.currentText) then
			self.textObject.text = self.textObject.text..self.currentText:sub(#self.textObject.text + 1, #self.textObject.text + 1)
			self.characterWait = self.CHARACTER_WAIT_MAX
		elseif (self.characterWait == 0) then
			self.state = "idle"
		else
			self.characterWait = self.characterWait - 1
		end
	end
end

function RPGText:skip()
end

function RPGText:removeSelf()
	if (self.textObject) then
		self.textObject:removeSelf()
		self.textObject = nil
	end
	if (self.continueButton) then
		self.continueButton:removeEventListener("touch", self)
		self.continueButton:removeSelf()
		self.continueButton = nil
	end
end