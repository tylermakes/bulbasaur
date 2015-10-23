require("class")
require("bulb_color")

BulbGameSettings = class(function(c)
	local types = {}
	types["strawberry"] = { id=1, tileName="strawberry", cost=1001, color=BulbColor(1,0,0) }
	types["orange"] = { id=2, tileName="orange", cost=1002, color=BulbColor(1,0.6,0) }
	types["avocado"] = { id=3, tileName="avocado", cost=1003, color=BulbColor(0,0.6,0) }
	types["blueberries"] = { id=4, tileName="blueberries", cost=1004, color=BulbColor(0,0,1) }
	types["lemon"] = { id=5, tileName="lemon", cost=1005, color=BulbColor(1,1,0.6) }
	types["carrots"] = { id=6, tileName="carrots", cost=1007, color=BulbColor(1,0.8,0) }
	types["beets"] = { id=7, tileName="beets", cost=10010, color=BulbColor(0.8,0,.5) }
	types["peas"] = { id=8, tileName="peas", cost=1009, color=BulbColor(0,0.8,0) }
	-- types["asparagus"] = { id=7, tileName="asparagus", cost=1008, color=BulbColor(0.3,0.6,0.3) }
	-- types["pineapple"] = { id=9, tileName="pineapple", cost=1006, color=BulbColor(1,1,0) }
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
end)

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

function BulbGameSettings:getTextByName(name)
	return self.talking[name]
end