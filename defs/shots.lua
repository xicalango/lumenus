
local shots = {
    small = {
        graphics = {
            image = love.graphics.newImage("media/p4x4.png"),
            offset = {2,2},
            tint={0,0,255}
        },
        damage = 1
    },
    
    big = {
        graphics = {
            image = love.graphics.newImage("media/c8x8.png"),
            offset = {4,4},
            tint={255,0,0}
        },
        damage = 5,
        bouncy = true
    }
}

return shots