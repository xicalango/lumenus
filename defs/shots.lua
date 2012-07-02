-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local shots = {
    small = {
        graphics = {
            image = love.graphics.newImage("media/p4x4.png"),
            offset = {2,2},
            tint={100,100,255}
        },
        damage = 1,
    },
    
    big = {
        graphics = {
            image = love.graphics.newImage("media/c8x8.png"),
            offset = {4,4},
            tint={255,0,0}
        },
        damage = 5,
        bouncy = true
    },
    
    line = {
        graphics = {
            image = love.graphics.newImage("media/l8x24.png"),
            offset = {4,12},
            tint={255,0,0}
        },
        damage = 3,
        bouncy = false
    },
    lineb = {
        graphics = {
            image = love.graphics.newImage("media/l8x24.png"),
            offset = {4,12},
            tint={0,0,255}
        },
        damage = 1,
        bouncy = false
    },
    
    vulcan = {
        graphics = {
            image = love.graphics.newImage("media/p1x1.png"),
            offset = {0,0}
        },
        
        damage = 1,
        bounce = false
    },
    
    vbig = {
        graphics = {
            image = love.graphics.newImage("media/bigshot.png"),
            offset = {8,12},
            tint = {255,0,255}
        },
        
        damage = 10,
        bounce = false
    }
}

return shots
