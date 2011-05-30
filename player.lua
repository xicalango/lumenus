-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local Player = {}
Player.__index = Player

function Player.create()
    local self = {}
    setmetatable(self, Player)
    
    self.ship = Ship.create( {0,0,255} )

    --self.ship:mountWeapon("left","big")
    self.ship:mountWeapon("center","small")
    --self.ship:mountWeapon("right","big")
    
    self.fireTrigger = false
    
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
    
    if self.fireTrigger then
        self.ship:shoot(dt, 0)
    end
    
end


return Player