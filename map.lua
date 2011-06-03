
local Map = {}
Map.__index = Map

function Map.create()
    local self = {}
    setmetatable(self,Map)
    
    self.shots = {}
    self.mobs = {}
    
    self.createMobTimer = math.random()*2
    
    self.playtime = 60
    
    self.enemyTypes = {"vsmall"}
    
    --self:createMob( "small", 100, -10, 1)

    return self
end

function Map:onPlayerDeath()
    self.shots = {}
    self.mobs = {}
    self.playtime = self.playtime + 10
end

function Map:reset()
    self.shots = {}
    self.mobs = {}
    self.playtime = 60
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

    self.createMobTimer = self.createMobTimer - dt
    
    if self.createMobTimer <= 0 then
        self.createMobTimer = math.random()*2
        
        self:createMob( util.takeRandom(self.enemyTypes) , math.random(borders.left, borders.right), -10, 1)
    end
    
    self.playtime = self.playtime - dt
    
    if self.playtime < 0 then
        gamestate:change("Shop")

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

function Map:createShot( defstr, x, y, phi, v, owner, rspeed, flyfn )
    
    local _phi = math.rad(phi-90)
    
    local dx = math.cos(_phi)
    local dy = math.sin(_phi)
    
    local newShot = Shot.create( defstr, x, y, dx, dy, v, owner, rspeed, math.rad(phi),flyfn )
        
    table.insert(self.shots, newShot)
end

function Map:createMob( defstr, x, y, dy )
    local newMob = Mob.create( defstr, x, y, dy )

    table.insert(self.mobs, newMob)
end

function Map:getFirstMob()
    return self.mobs[#self.mobs]
end

return Map
