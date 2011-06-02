
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
    self.x = x
    self.y = y

    self.dx = 0
    self.dy = dy or 0

    self.flyfn = self.def.flyfn or util.move

    self.ship = Ship.create(self.def.tint)
    print("a",self.def.tint)

    for pos,weapon in pairs(self.def.weapons) do
        self.ship:mountWeapon( pos, weapon )
    end

    self.state = Mob.States.FLY

    return self
end

function Mob:update(dt)
    self.x, self.y = self.flyfn( dt, self.x, self.y, self.dx, self.dy, self.def.speed )

    if self.y > 600 then
        self.state = Mob.States.DIE
    end
end

function Mob:draw()
    self.ship:draw()
end

return Mob

