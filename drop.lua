-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local Drop = {}
Drop.__index = Drop

local drops = require("defs/drops")

Drop.States = {
    FLY = 0,
    DIE = 1
}

function Drop.create( defstr, x, y, dx, dy, speed, amount, tint, speedx )
    local self = {}
    setmetatable(self,Drop)
    
    self.def = drops[defstr]
    
    self.x = x
    self.y = y
    
    self.dx = dx
    self.dy = dy
    
    self.speed = speed or 200
    self.speedx = speedx or self.speed/2
    
    self.phi = 0
    self.rspeed = 100
    
    self.state = Drop.States.FLY
    
    self.tint = tint
    
    self.followPlayer = false
    
    self.amount = amount
    
    return self
end

function Drop:update(dt)
    if not self.followPlayer then
        --print(util.dstsq( self.x, self.y, player.ship.x, player.ship.y))
        local collectRad = player:getCollectRad()
        if not self.followPlayer and (player.ship.y < borders.itemGet or (player.mod and util.dstsq( self.x, self.y, player.ship.x, player.ship.y) <= collectRad*collectRad)) then
            self.followPlayer = true
            self.speed = 400
            self.speedx = 400
        end
        
        
    end

    if self.followPlayer then
        local phi = math.atan2(player.ship.y - self.y, player.ship.x - self.x)
        self.dx = math.cos(phi)
        self.dy = math.sin(phi)
    else
        self.dy = self.dy + dt
    end

    self.x, self.y = util.move( dt, self.x, self.y, self.dx, self.dy, self.speedx, self.speed )
    
    self.phi = self.phi + self.rspeed * dt
    
    if self.y > 700 then
        self.state = Drop.States.DIE
    end
    
    if self.x < borders.left then
        self.x = borders.left + 1
        self.dx = -self.dx
    elseif self.x > borders.right then
        self.x = borders.right - 1
        self.dx = -self.dx
    end
    
	if not self.def.ignoresPlayer then
		if player.ship:collides(self.x,self.y) then
			if self.def.onCollide then
				self.def.onCollide(self)
			end
			
			if self.def.sound then
				TEsound.play(wavetable[self.def.sound],"drop", .7, math.random()*0.4 + 0.8 )
			end
			
			self.state = Drop.States.DIE
		end
	end
end

function Drop:draw()
     util.drawGraphic(self.def.graphics, self.x, self.y, nil,nil,math.rad(self.phi),self.tint)
end

return Drop
