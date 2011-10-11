-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local Player = {}
Player.__index = Player

local graphics = {
        image = love.graphics.newImage( "media/ship.png"),
        offset = {16,12},
        tint = {0,0,255},
        weaponOffset = {
            left = {-16,-2},
            right = {16,-2},
            center = {0,-12}
        }
    }

    
function Player.create()
    local self = {}
    setmetatable(self, Player)
    
    self.ship = Ship.create( graphics, owner.player )
	
	self.supShips = {}
	
    
    self.fireTrigger = false
    self.fireBlock = false
    
    self.score = 0
    
    self.lives = 3
    
    self.invincible = true
    self.invincibleTimer = 3
    
    self.maxEnergy = 3000
    self.energy = self.maxEnergy
    
    self.energyRegain = 500
    
    self.energyConsume = 0
    
    --self.collectRad = 50
    
    self.scoreMultiplier = {
        mult = 0,
        duration = 2
    }
    
    --self.focus = false
    
    self.flyDir = {
        left = false,
        right = false,
        up = false,
        down = false
        }
        
    self.extras = {
        focus = {
            level = 0,
            maxLevel = 3
        },
        
        speed = {
            level = 1,
            maxLevel = 5
        }
        
    }
    
    self.shotTimer = 0
    self.shotCounter = 0
    self.maxShotHits = 0
    self.maxShotTime = 2
    
    self:setModifier(false)
    
    return self
end

function Player:addSupShip(offsetX, offsetY)
	local supShip = Ship.create( self.ship.graphics, owner.player )

	supShip.follow = self.ship
	supShip.followDst.x = offsetX
	supShip.followDst.y = offsetY
	
	table.insert(self.supShips, supShip)
	table.insert(self.ship.followers, supShip)
end

function Player:getCollectRad()
    return 50 + (self.extras.focus.level-1) * 15
end

function Player:incMultiplier(x,y)
    self.scoreMultiplier.mult = self.scoreMultiplier.mult + 1
    self.scoreMultiplier.duration = 2
    
    
    if self.scoreMultiplier.mult > 1 then
        TEsound.play(wavetable["beep"], "effect", nil, self.scoreMultiplier.mult/100 +0.5)
    end
    
    si:setMultiplier(x,y)
end

function Player:draw()
    if self.invincible then
        if framecounter % 2 ~= 0 then
			for i,s in ipairs(self.supShips) do
				s:draw()
			end

            self.ship:draw()
        end
    else
		for i,s in ipairs(self.supShips) do
			s:draw()
		end

        self.ship:draw()
    end
end

function Player:stop()
    self.flyDir = {
        left = false,
        right = false,
        up = false,
        down = false
        }
        
    self.fireTrigger = false
    self.fireBlock = false
end

function Player:reset()
    self.ship.y = 500
    self.ship.x = (borders.right-borders.left)/2
    
    self.flyDir = {
        left = false,
        right = false,
        up = false,
        down = false
        }
    
    self.scoreMultiplier = {
        mult = 0,
        duration = 1,
        changed = false
    }
        
    self.fireTrigger = false
    self.fireBlock = false
    self.energy = self.maxEnergy
    
    self:setModifier(false)
    
    self.invincible = true
    self.invincibleTimer = 3
    
    self.shotTimer = 0
    self.shotCounter = 0
	
	self.ship.tintOverride = nil
end

function Player:keypressed(key)
    if util.keycheck(key,keyConfig.left) then
        self.flyDir.left = true
    elseif util.keycheck(key,keyConfig.right) then
        self.flyDir.right = true
    elseif util.keycheck(key,keyConfig.up) then
        self.flyDir.up = true
    elseif util.keycheck(key,keyConfig.down) then
        self.flyDir.down = true
    elseif util.keycheck(key,keyConfig.shoot) then
        self.fireTrigger = true
    elseif util.keycheck(key,keyConfig.modifier) then
        self:setModifier(true)
    end
end

function Player:keyreleased(key)
    if util.keycheck(key,keyConfig.left) then
        self.flyDir.left = false
    elseif util.keycheck(key,keyConfig.right) then
        self.flyDir.right = false
    elseif util.keycheck(key,keyConfig.up) then
        self.flyDir.up = false
    elseif util.keycheck(key,keyConfig.down) then
        self.flyDir.down = false
    elseif util.keycheck(key,keyConfig.shoot) then
        self.fireTrigger = false
        self.energyConsume = 0
    elseif util.keycheck(key,keyConfig.modifier) then
        self:setModifier(false)
    end
end

function Player:setModifier(value)
    if self.extras.focus.level > 0 then
        self.mod = value
        if self.mod then
            self.ship.handicap = 100 - 10 *(self.extras.focus.level-1)
        else
            self.ship.handicap = nil
		end
    else
        self.mod = false
    end
end

function Player:update(dt)
    if self.flyDir.left then
        self.ship.dx = -1
    elseif self.flyDir.right then
        self.ship.dx = 1
    else
        self.ship.dx = 0
    end
    
    if self.flyDir.up then
        self.ship.dy = -1
    elseif self.flyDir.down then
        self.ship.dy = 1
    else
        self.ship.dy = 0
    end

    self.ship:update(dt)
	
	for i,s in ipairs(self.supShips) do
		s:update(dt)
	end
        
    if self.ship.y + self.ship.graphics.offset[2] > 600 then
        self.ship.y = 600 - self.ship.graphics.offset[2]
    end
    
    if not self.fireBlock and self.fireTrigger then
        local de = self.ship:shoot(dt, 0, self.mod, self.energy)
		
		for i,s in ipairs(self.supShips) do
			s:shoot(dt, 0, self.mod)
		end
        
        self.energyConsume = de/dt
        
        self.energy = self.energy - de
        
        if self.energy <= 0 then
            self.energy = 0
            self.fireBlock = true
        end

    end
    
    if self.energy < self.maxEnergy then
        if self.mod then
            self.energy = self.energy + dt * self.energyRegain * 1.1
        else
            self.energy = self.energy + dt * self.energyRegain
        end
    
        
        if self.fireBlock and self.energy > 0.1 * self.maxEnergy then
            self.fireBlock = false
        end
        
        if self.energy > self.maxEnergy then
            self.energy = self.maxEnergy
        end
    end
    
    if self.invincible then
        self.invincibleTimer = self.invincibleTimer - dt
        if self.invincibleTimer <= 0 then
            self.invincible = false
        end
    end
    
        
    if self.scoreMultiplier.mult > 0 then
        self.scoreMultiplier.duration = self.scoreMultiplier.duration - dt
        
        if self.scoreMultiplier.duration <= 0 then
            self.scoreMultiplier.mult = 0
            TEsound.pitch("music", 1)
        end
    end
    
    if self.shotTimer > 0 then
        self.shotTimer = self.shotTimer - dt
        
        if self.shotTimer > 0 then       
            local color = {0,0,0}
            color[1] = (self.shotCounter/self.maxShotHits)*127 + 127
            color[1] = color[1] * (self.shotTimer/self.maxShotTime)
            color[3] = 255 - color[1]
            self.ship.tintOverride = color
        else
            self.ship.tintOverride = nil
			self.shotTimer = 0
			self.shotCounter = 0
        end
    end
    
end

function Player:damage(dmg)
    if self.invincible then 
        return
    end

	self.shotCounter = self.shotCounter + 1
	self.shotTimer = self.maxShotTime
	if self.shotCounter > self.maxShotHits then
		self:destroy()
	end
end

function Player:destroy()
    if self.invincible then 
        return
    end
    
    TEsound.play(wavetable["playerExplosion"])

    self.lives = self.lives - 1
    
	si:doLightning()
    
    self:changeScore(-500,self.ship.x,self.ship.y)
    
    explosionPS:setColor( self.ship.graphics.tint[1], self.ship.graphics.tint[2], self.ship.graphics.tint[3], 255, 255, 0, 0, 0 )
    explosionPS:setPosition(self.ship.x, self.ship.y)
    explosionPS:setSize(1, 1)
    explosionPS:start()

    self:reset()
    
    for i = 1,4 do
        currentmap:createDrop("junk" .. tostring(i), self.ship.x, self.ship.y-20, math.random()-0.5, -1, math.random(50,200), 100 , graphics.tint, math.random(50,100) )
    end
    
    if self.lives <= 0 then
        gamestate:change("GameOver")
    end

    
    currentmap:onPlayerDeath()

end

function Player:changeScore(dScore,x,y)
    if dScore > 0 and self.scoreMultiplier.mult > 1 then
        dScore = dScore * self.scoreMultiplier.mult
    end

    self.score = self.score + dScore
    if self.score < 0 then
        self.score = 0
    end
    
    if x and y then
        si:add(dScore,x,y)
    end
end

function Player:changeEnergy(dEnergy)
    self.energy = self.energy + (dEnergy/100 * self.maxEnergy)
    if self.energy > self.maxEnergy then
        self.energy = self.maxEnergy
    end
end

return Player
