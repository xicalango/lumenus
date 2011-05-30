-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local Ship = {}
Ship.__index = Ship

local graphics = {
        image = love.graphics.newImage( "media/ship.png"),
        offset = {16,12}
        }

function Ship.create(tint)
    local self = {}
    setmetatable(self,Ship)
    
    self.graphics = {
        image = graphics.image,
        offset = graphics.offset,
        tint = tint
        }
    
    self.x = 0
    self.y = 0
    
    self.dx = 0
    self.dy = 0
    
    self.speed = 200
    
    self.weapons = {
        left = {
            offset = {-self.graphics.offset[1],-self.graphics.offset[2]},
            weapon = nil
            },
        right = {
            offset = {self.graphics.offset[1],-self.graphics.offset[2]},
            weapon = nil
            },
        center = {
            offset = {0,-self.graphics.offset[2]},
            weapon = nil
            }
    }
    
    return self
end

function Ship:mountWeapon(pos,defstr)
    self.weapons[pos].weapon = Weapon.create(defstr)
end

function Ship:draw()
    util.drawGraphic(self.graphics, self.x, self.y)
end

function Ship:update(dt)
    self.x, self.y = util.move( dt, self.x, self.y, self.dx, self.dy, self.speed )
    
    if self.x-self.graphics.offset[1] < borders.left then
        self.x = borders.left + self.graphics.offset[1]
    end

    if self.x+self.graphics.offset[1] > borders.right then
        self.x = borders.right - self.graphics.offset[1]
    end
    
    if self.y + self.graphics.offset[2] > 600 then
        self.y = 600 - self.graphics.offset[2]
    end

    
    for k,w in pairs(self.weapons) do
        if w.weapon then
            w.weapon:update(dt)
        end
    end
    
end

function Ship:shoot(dt,phi)
    for k,w in pairs(self.weapons) do
        if w.weapon then
            w.weapon:shoot(dt,self.x + w.offset[1] ,self.y + w.offset[2],phi)
        end
    end
end

return Ship
