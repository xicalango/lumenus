-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local mobs = require('defs/mobs')

local Mob = {}
Mob.__index = Mob

Mob.States = {
    FLY = 0,
    DIE = 1
}

function Mob.create(defstr ,x, y, dy, path)
    local self = {}
    setmetatable(self,Mob)

    self.def = mobs[defstr]

    self.health = self.def.health

    self.ship = Ship.create(self.def.graphics, owner.enemy)
    
    self.ship.x = x
    self.ship.y = y
    
    self.ship.dx = 0
    self.ship.dy = dy
	
	self.path = path
    
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
	if self.path then
		self.ship:update(dt,self.path:getFlyFn())
		
		if self.path:reachedNode(self.ship.x, self.ship.y) then
            local nextNode = self.path:nextNode()
            if nextNode == nil then
                self.path = nil
            end
        end
	else
		self.ship:update(dt,self.def.flyfn)
	end
	
    if math.random(self.def.shotChance) == 1 then
        self.ship:shoot(dt, 180)
    end
    
    if player.ship:collides( self.ship.x, self.ship.y ) then
        player:destroy()
        self.state = Mob.States.DIE
    end
    
    if self.ship.y > 610 then
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
    if self.state == Mob.States.DIE then
        return
    end

    self.health = self.health - dmg
    
    damagePS:setDirection(-math.pi/2)
    damagePS:setPosition(sx,sy)
    damagePS:setColors( self.ship.graphics.tint[1], self.ship.graphics.tint[2], self.ship.graphics.tint[3], 255, self.ship.graphics.tint[1], self.ship.graphics.tint[2], self.ship.graphics.tint[3], 0 )
    damagePS:start()
        
    player:changeScore(dmg)
    
    if self.health <= 0 then
        TEsound.play(wavetable["explosion"])
		
		--si:doLightning()
    
        player:incMultiplier(self.ship.x,self.ship.y)
        player:changeScore(self.def.score,sx,sy)

        explosionPS:setColors( 
            self.ship.graphics.tint[1], self.ship.graphics.tint[2], self.ship.graphics.tint[3], 
            255, 255, 0, 0, 0 
            )
        explosionPS:setPosition(self.ship.x, self.ship.y)
        explosionPS:start()
        
        for i = 1,4 do
                currentmap:createDrop(
                    self.def.junktile .. tostring(i), 
                    self.ship.x, self.ship.y, 
                    math.random()-0.5, 1, 
                    math.random(50,200), 
                    self.def.score/10 , 
                    self.def.graphics.tint, 
                    math.random(50,100) 
                )
        end
        

        
        if self.def.morphTo then
            self:morph(self.def.morphTo)
        else
            self.state = Mob.States.DIE
            
            local drop = math.random(1000)
            
            if drop < 50 then
                currentmap:createDrop("battery", self.ship.x, self.ship.y, math.random()-0.5, 1, 50, self.def.score/10 )
            elseif drop > 995 then
                currentmap:createDrop("life", self.ship.x, self.ship.y, math.random()-0.5, 1, 50, self.def.score/10 )
            end
        end
    end
    
end

return Mob

