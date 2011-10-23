
local TimelineCtrl = require("timeline.lua")

local Map = {}
Map.__index = Map

function Map.create(mapDef, gui)
    local self = {}
    setmetatable(self,Map)
    
	self.gui = gui
	
    self.shots = {}
    self.mobs = {}
    self.drops = {}
    
    self.createMobTimer = math.random()*2
    
    self.playtime = 90
	
    self.timeline = TimelineCtrl.create(mapDef.timeline)
    
    self.enemyTypes = {"vsmall"}
    
	self.gui:clearMapElements()

	
    --self:createMob( "small", 100, -10, 1)

    return self
end

function Map:onPlayerDeath()
    self.shots = {}
    self.mobs = {}
    self.playtime = self.playtime + 10
    self.createMobTimer = 1 + math.random()
	self.gui:clearMapElements()
    self.timeline:onPlayerDeath(self)
end

function Map:reset()
    self.shots = {}
    self.mobs = {}
    self.drops = {}
    self.playtime = 90
	self.gui:clearMapElements()
    self.timeline:reset()
end


function Map:update(dt)
	
	self.timeline:update(dt,self)

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
    
    
    for i,d in ipairs(self.drops) do
        d:update(dt)
        
        if d.state == Drop.States.DIE then
            table.remove(self.drops,i)
        end
    end

    

end

function Map:finish()
	gamestate:change("Shop")
end

function Map:draw()
    for i,d in ipairs(self.drops) do
        d:draw()
    end    

    for i,m in ipairs(self.mobs) do
        m:draw()
    end

    for i,s in ipairs(self.shots) do
        s:draw()
    end
end

function Map:createShot( defstr, x, y, phi, v, owner, rspeed, flyfn, i )
    
    local _phi = math.rad(phi-90)
    
    local dx = math.cos(_phi)
    local dy = math.sin(_phi)
    
    local newShot = Shot.create( defstr, x, y, dx, dy, v, owner, rspeed, math.rad(phi),flyfn, i )
        
    table.insert(self.shots, newShot)
	
	return newShot
end

function Map:createMob( defstr, x, y, dy, path )
    local newMob = Mob.create( defstr, x, y, dy, path )

    table.insert(self.mobs, newMob)
	
	return newMob
end

function Map:createDrop( defstr, x, y, dx, dy, speed, amount, tint, speedx )
    local newDrop = Drop.create(defstr, x, y, dx, dy, speed, amount, tint, speedx )

    table.insert(self.drops, newDrop)
	
	return newDrop
end

function Map:getFirstMob()
    return self.mobs[#self.mobs]
end

function Map:createGui( typ, label, contentFn )
	return self.gui:insertMapElement( typ, label, contentFn )
end

function Map:removeGui( n )
	self.gui:removeMapElement(n)
end

return Map
