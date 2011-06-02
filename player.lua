-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local Player = {}
Player.__index = Player

local graphics = {
        image = love.graphics.newImage( "media/ship.png"),
        offset = {16,12},
        tint = {0,0,255},
        weaponOffset = {
            left = {-16,-12},
            right = {16,-12},
            center = {0,-12}
        }
    }

function Player.create()
    local self = {}
    setmetatable(self, Player)
    
    self.ship = Ship.create( graphics, owner.player )

    --self.ship:mountWeapon("left","big")
    self.ship:mountWeapon("center","big")
    --self.ship:mountWeapon("right","big")
    
    self.fireTrigger = false
    
    self.score = 0
    
    return self
end

function Player:draw()
    self.ship:draw()
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
    
end

function Player:damage(dmg)
    
end

return Player
