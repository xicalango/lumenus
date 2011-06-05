
local junkCollide = function(self)
    player:changeScore(self.amount,self.x,self.y)
    player:changeEnergy(1)
    player.scoreMultiplier.duration = player.scoreMultiplier.duration + self.amount/100
    if player.scoreMultiplier.duration > 1 then player.scoreMultiplier.duration = 1 end
end

local drops = {
    battery = {
        graphics = {
            image = love.graphics.newImage( "media/battery.png" ),
            offset = {6,12},
        },
        
        onCollide = function(self)
            player:changeEnergy(self.amount)
        end
    },
    
    life = {
        graphics = {
            image = love.graphics.newImage( "media/life.png" ),
            offset = {11,11},
            tint = {0,0,255}
        },
        
        onCollide = function(self)
            player.lives = player.lives + 1
        end
    },
    
    junk1 = {
        graphics = {
            image = love.graphics.newImage( "media/junk1.png" ),
            offset = {8,6}
        },
        
        onCollide = junkCollide
    },
    
    junk2 = {
        graphics = {
            image = love.graphics.newImage( "media/junk2.png" ),
            offset = {8,6}
        },
        
        onCollide = junkCollide
    },
    
    junk3 = {
        graphics = {
            image = love.graphics.newImage( "media/junk3.png" ),
            offset = {8,6}
        },
        
        onCollide = junkCollide
    },
    
    junk4 = {
        graphics = {
            image = love.graphics.newImage( "media/junk4.png" ),
            offset = {8,6}
        },
        
        onCollide = junkCollide
    },
}

return drops