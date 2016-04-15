require("class")
require("bulb_enemy")

BulbEnemyZombie = class(function(c, map, enemyInfo)
	c.enemy = BulbEnemy(map, enemyInfo)
	c.LIFE_STAGES = 6
	c.STAGE_DURATION = 20
	c.lifeStage = 0
	c.stageTime = 0
	c.colorSteps = {}
	c.colorSteps.r = (c.enemy.tileInfo.color.r - 0.6)/c.LIFE_STAGES
	c.colorSteps.g = (c.enemy.tileInfo.color.g - 0.8)/c.LIFE_STAGES
	c.colorSteps.b = (c.enemy.tileInfo.color.b - 0.3)/c.LIFE_STAGES
	c.location = c.enemy.location
end)

function BulbEnemyZombie:create(group)
	self.enemy:create(group)
end

function BulbEnemyZombie:update(player)
	if (self.lifeStage < self.LIFE_STAGES) then
		self.enemy:update(player)
		if (self.stageTime >= self.STAGE_DURATION) then
			self.lifeStage = self.lifeStage + 1
			self.enemy.enemyView:setFillColor( 
				self.enemy.tileInfo.color.r - (self.colorSteps.r*self.lifeStage),
				self.enemy.tileInfo.color.g - (self.colorSteps.g*self.lifeStage),
				self.enemy.tileInfo.color.b - (self.colorSteps.b*self.lifeStage)
				)
			self.stageTime = 0
			self.enemy.TRANSITION_SPEED = 3 * self.lifeStage
			self.STAGE_DURATION = 30 * (self.lifeStage + 1)
		else
			self.stageTime = self.stageTime + 1
		end
	else
		if (self.enemy.transitioning ~= 0) then
			self.enemy:update(player)
		else
			self.enemy.enemyView:setFillColor( 0.6, 0.7, 0.6)
		end
	end

	self.location = self.enemy.location
end


function BulbEnemyZombie:removeSelf( )
	if (self.enemy) then
		self.enemy:removeSelf()
		self.enemy = nil
	end
end