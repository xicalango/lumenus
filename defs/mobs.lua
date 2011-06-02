local mobs = {
    small = {
        weapons = {
            center = "small"
        },
        speed = 100,
        
        graphics = {
        image = love.graphics.newImage( "media/eship.png"),
        offset = {16,12},
        tint = {0,255,0},
        
        weaponOffset = {
            left = {-16,12},
            right = {16,12},
            center = {0,12}
            }
        },
        
        health = 2,
        
        score = 100
        
    },
    
    medium = {
        weapons = {
            left = "small",
            right = "small"
        },
        speed = 100,
        
        graphics = {
        image = love.graphics.newImage( "media/eship.png"),
        offset = {16,12},
        tint = {255,255,0},
        
        weaponOffset = {
            left = {-16,12},
            right = {16,12},
            center = {0,12}
            }
        },
        
        health = 2,
        
        score = 100,
        
        morphTo = "small"
        
    }

}

return mobs
