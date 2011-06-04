
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
        
        onCollide = function(self)
            player:changeScore(self.amount,self.x,self.y)
        end
    },
    
    junk2 = {
        graphics = {
            image = love.graphics.newImage( "media/junk2.png" ),
            offset = {8,6}
        },
        
        onCollide = function(self)
            player:changeScore(self.amount,self.x,self.y)
        end
    },
    
    junk3 = {
        graphics = {
            image = love.graphics.newImage( "media/junk3.png" ),
            offset = {8,6}
        },
        
        onCollide = function(self)
            player:changeScore(self.amount,self.x,self.y)
        end
    },
    
    junk4 = {
        graphics = {
            image = love.graphics.newImage( "media/junk4.png" ),
            offset = {8,6}
        },
        
        onCollide = function(self)
            player:changeScore(self.amount,self.x,self.y)
        end
    },
}

return drops