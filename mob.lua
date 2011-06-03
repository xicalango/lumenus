
local mobs = require('defs/mobs.lua')

local Mob = {}
Mob.__index = Mob

Mob.States = {
    FLY = 0,
    DIE = 1
}

function Mob.create(defstr ,x, y, dy)
    local self = {}
    setmetatable(self,Mob)

    self.def = mobs[defstr]

    self.health = self.def.health

    self.ship = Ship.create(self.def.graphics, owner.enemy)
    
    self.ship.x = x
    self.ship.y = y
    
    self.ship.dx = 0
    self.ship.dy = dy
    
    self.ship.speed = self.def.speed
    
    --print("a",self.def.tint)

    for pos,weapon in pairs(self.def.weapons) do
        self.ship:mountWeapon( pos, weapon )
    end

    self.state = Mob.States.FLY
    
    return self
end

function Mob:morph(defstr)
    local oldx,oldy,olddy = self.ship.x, self.ship.y, self.ship.dy
    
    self.def = mobs[defstr]

    self.health = self.def.health

    self.ship = Ship.create(self.def.graphics, owner.enemy)
    
    self.ship.x = oldx
    self.ship.y = oldy
    
    self.ship.dx = 0
    self.ship.dy = olddy
    
    self.ship.speed = self.def.speed
    
    for pos,weapon in pairs(self.def.weapons) do
        self.ship:mountWeapon( pos, weapon )
    end

    self.state = Mob.States.FLY
end

function Mob:update(dt)
    self.ship:update(dt,self.def.flyfn)
    --self.x, self.y = self.flyfn( dt, self.x, self.y, self.dx, self.dy, self.def.speed )

    if math.random(self.def.shotChance) == 1 then
        self.ship:shoot(dt, 180)
    end
    
    if player.ship:collides( self.ship.x, self.ship.y ) then
        player:destroy()
        self.state = Mob.States.DIE
    end
    
    if self.ship.y > 600 then
        self.state = Mob.States.DIE
        --player:changeScore(-self.def.score)
    end
    
    if self.def.onAfterUpdate then
        self.def.onAfterUpdate(self)
    end
end

function Mob:draw()
    self.ship:draw()
    
    if self.def.onAfterDraw then 
        self.def.onAfterDraw(self)
    end
    
end

function Mob:damage(dmg,sx,sy)
    self.health = self.health - dmg
    
    damagePS:setDirection(-math.pi/2)
    damagePS:setPosition(sx,sy)
    damagePS:setColor( self.ship.graphics.tint[1], self.ship.graphics.tint[2], self.ship.graphics.tint[3], 255, self.ship.graphics.tint[1], self.ship.graphics.tint[2], self.ship.graphics.tint[3], 0 )
    damagePS:start()
        
    player:changeScore(dmg)
    
    if self.health <= 0 then
        player:changeScore(self.def.score)

        explosionPS:setColor( self.ship.graphics.tint[1], self.ship.graphics.tint[2], self.ship.graphics.tint[3], 255, 255, 0, 0, 0 )
        explosionPS:setPosition(self.ship.x, self.ship.y)
        explosionPS:start()
        
        if self.def.morphTo then
            self:morph(self.def.morphTo)
        else
            self.state = Mob.States.DIE
        end
    end
    
end

return Mob

