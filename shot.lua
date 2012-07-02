-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local shots = require('defs/shots.lua')

local Shot = {}
Shot.__index = Shot

Shot.States = {
    FLY = 0,
    DIE = 1
}

function Shot.create(defstr,x,y,dx,dy,speed,owner,rspeed,phi,flyfn,i)
    local self = {}
    setmetatable(self,Shot)
    
    self.def = shots[defstr]
    
    self.x = x or 0
    self.y = y or 0
    
    
    self.dx = dx or 0
    self.dy = dy or 0

    self.phi = phi

    if rspeed then
        self.rspeed = rspeed
    end
    
    self.speed = speed or 100
    
    self.flyfn = flyfn or util.move
    
    self.state = Shot.States.FLY
    
    self.lifetime = 0

    self.owner = owner
    
    self.i = i
    
    return self
end

function Shot:draw()
    util.drawGraphic(self.def.graphics,self.x,self.y,nil,nil,self.phi)
end

function Shot:update(dt)
        self.x, self.y = self.flyfn(dt,self.x,self.y,self.dx,self.dy,self.speed,nil,self)
        
        if self.rspeed then
            self.phi = self.phi + self.rspeed * dt
        end
        
        self.lifetime = self.lifetime + dt
        
        if self.y < 0 or self.y > 620 or self.lifetime > 15 then
            self.state = Shot.States.DIE
        end
        
        if self.x < borders.left or self.x > borders.right then
            if self.def.bouncy then
                self.dx = -self.dx
                if self.x < borders.left then
                    self.x = borders.left
                elseif self.x > borders.right then
                    self.x = borders.right
                end
            else
                self.state = Shot.States.DIE
            end
        end

        if self.owner == owner.player then

            for i,m in ipairs(currentmap.mobs) do
                if m.ship:collides(self.x,self.y) then
                    m:damage(self.def.damage,self.x,self.y)
                    self.state = Shot.States.DIE
                end
            end

        elseif self.owner == owner.enemy then
            if player.ship:collides(self.x,self.y) then
                player:damage(self.def.damage)
                self.state = Shot.States.DIE
            end
        end

end

return Shot
