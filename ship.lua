-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local Ship = {}
Ship.__index = Ship

function Ship.create(graphics,owner)
    local self = {}
    setmetatable(self,Ship)
    
    self.graphics = graphics
    
    self.x = 0
    self.y = 0
    
    self.dx = 0
    self.dy = 0
    
    self.speed = 200
    
    self.weapons = {
        left = {
            offset = self.graphics.weaponOffset.left or {-self.graphics.offset[1],0},
            weapon = nil
            },
        right = {
            offset = self.graphics.weaponOffset.right or {self.graphics.offset[1],0},
            weapon = nil
            },
        center = {
            offset = self.graphics.weaponOffset.center or {0,0},
            weapon = nil
            }
    }
    
    self.owner = owner
	
	self.follow = nil
	self.followDst = { x = 0, y = 0 }
	self.followers = {}
	
    return self
end

function Ship:mountWeapon(pos,defstr)
    self.weapons[pos].weapon = Weapon.create(defstr, self.owner)
	
	for i,f in ipairs(self.followers) do
		f:mountWeapon(pos,defstr)
	end
end

function Ship:draw()
    util.drawGraphic(self.graphics, self.x, self.y, nil, nil, nil, self.tintOverride)
end

function Ship:update(dt,flyfn)
	if self.follow then
		self.x, self.y = self.follow.x + self.followDst.x, self.follow.y + self.followDst.y
	else
		flyfn = flyfn or util.move
		self.x, self.y = flyfn( dt, self.x, self.y, self.dx, self.dy, self.speed - (self.handicap or 0) )
	end
    
    if self.x-self.graphics.offset[1] < borders.left then
        self.x = borders.left + self.graphics.offset[1]
    end

    if self.x+self.graphics.offset[1] > borders.right then
        self.x = borders.right - self.graphics.offset[1]
    end


    
    for k,w in pairs(self.weapons) do
        if w.weapon then
            w.weapon:update(dt)
        end
    end
    
end

function Ship:shoot(dt,phi,modifier,energy)
    local de = 0

    for k,w in pairs(self.weapons) do
        if w.weapon then
            if not energy or energy >= w.weapon.def.energy then
                if w.weapon:shoot(dt,self.x + w.offset[1] ,self.y + w.offset[2],phi,0,modifier) then
                    de = de + w.weapon.def.energy
                end
            end
        end
    end
    
    return de
end

function Ship:collides(x,y)
    return 
        x > self.x - self.graphics.offset[1] and 
        x < self.x + self.graphics.offset[1] and 
        y > self.y - self.graphics.offset[2] and 
        y < self.y + self.graphics.offset[2]
end

return Ship
