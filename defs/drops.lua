
local junkCollide = function(self)
    player:changeScore(self.amount,self.x,self.y)
    player:changeEnergy(1)
    player.scoreMultiplier.duration = player.scoreMultiplier.duration + 0.1
    if player.scoreMultiplier.duration > 2 then player.scoreMultiplier.duration = 2 end
end

local drops = {
    battery = {
        graphics = {
            image = love.graphics.newImage( "media/battery.png" ),
            offset = {6,12},
        },
        
        onCollide = function(self)
            player:changeEnergy(100)
        end,
        
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
        
        onCollide = junkCollide,
        
        sound = "junk"
    },
    
    junk2 = {
        graphics = {
            image = love.graphics.newImage( "media/junk2.png" ),
            offset = {8,6}
        },
        
        onCollide = junkCollide,
        sound = "junk"

    },
    
    junk3 = {
        graphics = {
            image = love.graphics.newImage( "media/junk3.png" ),
            offset = {8,6}
        },
        
        onCollide = junkCollide,
        
        sound = "junk"

    },
    
    junk4 = {
        graphics = {
            image = love.graphics.newImage( "media/junk4.png" ),
            offset = {8,6}
        },
        
        onCollide = junkCollide,
        
        sound = "junk"

    },
}

return drops
