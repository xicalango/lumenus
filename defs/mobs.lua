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
            left = {-16,2},
            right = {16,2},
            center = {0,12}
            }
        },
        
        health = 2,
        
        score = 100,
        
        shotChance = 20
        
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
            left = {-16,2},
            right = {16,2},
            center = {0,12}
            }
        },
        
        health = 2,
        
        score = 100,
        
        morphTo = "small",
        
        shotChance = 20
        
    },
    
    hard = {
        weapons = {
            left = "small",
            center = "small",
            right = "small"
        },
        speed = 200,
        
        graphics = {
        image = love.graphics.newImage( "media/eship.png"),
        offset = {16,12},
        tint = {255,0,100},
        
        weaponOffset = {
            left = {-16,2},
            right = {16,2},
            center = {0,12}
            }
        },
        
        health = 5,
        
        score = 300,
        
        morphTo = "medium",
        
        shotChance = 20
        
    },
    
    vhard = {
        weapons = {
            left = "small",
            center = "small",
            right = "small"
        },
        speed = 200,
        
        graphics = {
        image = love.graphics.newImage( "media/eship.png"),
        offset = {16,12},
        tint = {255,0,0},
        
        weaponOffset = {
            left = {-16,2},
            right = {16,2},
            center = {0,12}
            }
        },
        
        health = 500,
        
        score = 3000,
        
        shotChance = 20
        
        
    }

}

return mobs
