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

    self.ship:mountWeapon("center","small")
    
    self.fireTrigger = false
    self.fireBlock = false
    
    self.score = 0
    
    self.lives = 3
    
    self.invincible = true
    self.invincibleTimer = 3
    
    self.maxEnergy = 3000
    self.energy = self.maxEnergy
    
    
    return self
end

function Player:draw()
    if self. invincible then
        if framecounter % 2 ~= 0 then
            self.ship:draw()
        end
    else
        self.ship:draw()
    end
end

function Player:reset()
    self.ship.y = 500
    self.ship.x = (borders.right-borders.left)/2
    
    self.ship.dx = 0
    self.ship.dy = 0
    self.fireTrigger = false
    self.fireBlock = false
    self.energy = self.maxEnergy
    
    self:setModifier(false)
    
    self.invincible = true
    self.invincibleTimer = 3
end

function Player:keypressed(key)
    if util.keycheck(key,keyConfig.left) then
        self.ship.dx = -1
    elseif util.keycheck(key,keyConfig.right) then
        self.ship.dx = 1
    elseif util.keycheck(key,keyConfig.up) then
        self.ship.dy = -1
    elseif util.keycheck(key,keyConfig.down) then
        self.ship.dy = 1
    elseif util.keycheck(key,keyConfig.shoot) then
        self.fireTrigger = true
    elseif util.keycheck(key,keyConfig.modifier) then
        self:setModifier(true)
    end
end

function Player:keyreleased(key)
    if util.keycheck(key,keyConfig.left) or util.keycheck(key,keyConfig.right) then
        self.ship.dx = 0
    elseif util.keycheck(key,keyConfig.up) or util.keycheck(key,keyConfig.down) then
        self.ship.dy = 0
    elseif util.keycheck(key,keyConfig.shoot) then
        self.fireTrigger = false
    elseif util.keycheck(key,keyConfig.modifier) then
        self:setModifier(false)
    end
end

function Player:setModifier(value)
    self.mod = value
    if self.mod then
        self.ship.handicap = 100
    else
        self.ship.handicap = nil
    end
end

function Player:update(dt)
    self.ship:update(dt)
    
        
    if self.ship.y + self.ship.graphics.offset[2] > 600 then
        self.ship.y = 600 - self.ship.graphics.offset[2]
    end
    
    if not self.fireBlock and self.fireTrigger then
        local energy = self.ship:shoot(dt, 0,self.mod,self.energy)
        
        if self.energy == energy then
            self.fireBlock = true
        end
        
        self.energy = energy
        
        
    end
    
    if self.energy < self.maxEnergy then
        self.energy = self.energy + dt * 500
        
        if self.fireBlock and self.energy > 0.25 * self.maxEnergy then
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
    
end

function Player:damage(dmg)
    if self.invincible then 
        return
    end

    self:destroy()
end

function Player:destroy()
    if self.invincible then 
        return
    end

    self.lives = self.lives - 1
    self.invincible = true
    self.invincibleTimer = 3
    
    currentmap:onPlayerDeath()
    
    self:changeScore(-500)
    
    explosionPS:setColor( self.ship.graphics.tint[1], self.ship.graphics.tint[2], self.ship.graphics.tint[3], 255, 255, 0, 0, 0 )
    explosionPS:setPosition(self.ship.x, self.ship.y)
    explosionPS:setSize(1, 1)
    explosionPS:start()
    
    if self.lives <= 0 then
        love.event.push("q")
    end
end

function Player:changeScore(dScore)
    self.score = self.score + dScore
    if self.score < 0 then
        self.score = 0
    end
end

return Player
