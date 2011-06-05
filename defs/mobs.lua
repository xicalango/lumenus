local mobs = {
    vsmall = {
        weapons = {
            center = "small"
        },
        speed = 100,
        
        graphics = {
        image = love.graphics.newImage( "media/eship.png"),
        offset = {16,12},
        tint = {150,255,150},
        
        weaponOffset = {
            left = {-16,2},
            right = {16,2},
            center = {0,12}
            }
        },
        
        health = 1,
        
        score = 50,
        
        shotChance = 70,
        
        junktile = "junk",
        
--[[
        flyfn = function(dt,x,y,dx,dy,speed)
            local xx,yy = util.move(dt,x,y,dx,dy,speed)
            
            return xx + math.sin(2*math.pi*0.01*y)*2, yy
        end
]]
        
    },
    
    vsmallsin = {
        weapons = {
            center = "small"
        },
        speed = 100,
        
        graphics = {
        image = love.graphics.newImage( "media/eship.png"),
        offset = {16,12},
        tint = {150,255,150},
        
        weaponOffset = {
            left = {-16,2},
            right = {16,2},
            center = {0,12}
            }
        },
        
        health = 1,
        
        score = 50,
        
        shotChance = 70,
        
        junktile = "junk",
        

        flyfn = function(dt,x,y,dx,dy,speed)
            local xx,yy = util.move(dt,x,y,dx,dy,speed)
            
            return xx + math.sin(2*math.pi*0.01*y)*3, yy
        end
        
    },

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
        
        shotChance = 50,

        junktile = "junk",
        
--[[
        flyfn = function(dt,x,y,dx,dy,speed)
            local xx,yy = util.move(dt,x,y,dx,dy,speed)
            
            local px = util.sign(player.ship.x - xx)
            
            return xx + px, yy
        end
]]
        
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
        
        health = 5,
        
        score = 500,
        
        morphTo = "small",
        
        shotChance = 50,
        junktile = "junk",

        
       
    },
    
    hard = {
        weapons = {
            left = "smallfast",
            center = "smallfast",
            right = "smallfast"
        },
        speed = 110,
        
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
        
        score = 1000,
        
        morphTo = "medium",
        
        shotChance = 70,
        
        junktile = "junk",
        
    },
    
    vhard = {
        weapons = {
            left = "smallfast",
            center = "smallfast",
            right = "smallfast"
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
        
        shotChance = 20,

        junktile = "junk",
        
        
    }

}

return mobs
