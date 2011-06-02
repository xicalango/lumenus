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

    self.ship:mountWeapon("left","followMob")
    self.ship:mountWeapon("center","small")
    self.ship:mountWeapon("right","followMob")
    
    self.fireTrigger = false
    
    self.score = 0
    
    self.lives = 3
    
    self.invincible = true
    self.invincibleTimer = 1
    
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
    end
end

function Player:keyreleased(key)
    if util.keycheck(key,keyConfig.left) or util.keycheck(key,keyConfig.right) then
        self.ship.dx = 0
    elseif util.keycheck(key,keyConfig.up) or util.keycheck(key,keyConfig.down) then
        self.ship.dy = 0
    elseif util.keycheck(key,keyConfig.shoot) then
        self.fireTrigger = false
    end
end

function Player:update(dt)
    self.ship:update(dt)
    
        
    if self.ship.y + self.ship.graphics.offset[2] > 600 then
        self.ship.y = 600 - self.ship.graphics.offset[2]
    end
    
    if self.fireTrigger then
        self.ship:shoot(dt, 0)
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
    
    self.score = self.score - 500
    
    if self.lives <= 0 then
        love.event.push("q")
    end
end

return Player
