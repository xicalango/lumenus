
local Map = {}
Map.__index = Map

function Map.create()
    local self = {}
    setmetatable(self,Map)
    
    self.shots = {}
    self.mobs = {}
    
    return self
end


function Map:update(dt)
    for i,s in ipairs(self.shots) do
        s:update(dt)
        
        if s.state == Shot.States.DIE then
            table.remove(self.shots,i)
        end
    end

    for i,m in ipairs(self.mobs) do
        m:update(dt)
        
        if m.state == Mob.States.DIE then
            table.remove(self.mobs,i)
        end
    end

end

function Map:draw()
    for i,m in ipairs(self.mobs) do
        m:draw()
    end

    for i,s in ipairs(self.shots) do
        s:draw()
    end    
end

function Map:createShot( defstr, x, y, phi, v, flyfn )
    
    phi = math.rad(phi-90)
    
    dx = math.cos(phi)
    dy = math.sin(phi)
    
    local newShot = Shot.create( defstr, x, y, dx, dy, v, flyfn )
        
    table.insert(self.shots, newShot)
end

function Map:createMob( defstr, x, y, dy )
    local newMob = Ship.create( defstr, x, y, dy )

    table.insert(self.mobs, newMob)
end

return Map
