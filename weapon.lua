
local weapons = require('defs/weapons.lua')

local Weapon = {}
Weapon.__index = Weapon


Weapon.states = {
    IDLE = 0,
    READY = 1,
    COOLDOWN = 2
}

function Weapon.create(defStr,owner)
    local self = {}
    setmetatable(self,Weapon)
    
    self.def = weapons[defStr]
        
    self.timer = 0
    
    self.state = Weapon.states.READY
    
    self.owner = owner
    
    return self
end

function Weapon:shoot(dt,x, y, phi,dy)
    if self.state == Weapon.states.READY then
        self:fireWeapon( dt, x, y, phi,dy )
        self.state = Weapon.states.COOLDOWN
        self.timer = 0
    end 
end

function Weapon:fireWeapon(dt, x,y,phi,dy)
    local _phi = phi

    for i=1,self.def.shotCount do       
    
        if self.def.phifn then
            _phi = self.def.phifn(dt,_phi,phi,i,self.def.shotCount,x,y)
        end
        
        currentmap:createShot( 
            self.def.shot, 
            x, y, 
            _phi, 
            self.def.shotSpeed + (dy or 0), 
            self.owner,
            self.def.flyfn )
    end
end

function Weapon:update(dt)
    if self.state == Weapon.states.COOLDOWN then
        self.timer = self.timer + dt
        if self.timer >= self.def.repeatTime/1000 then
            self.state = Weapon.states.READY
        end
    end
end

function Weapon:__tostring()
    return self.def.name
end

return Weapon
