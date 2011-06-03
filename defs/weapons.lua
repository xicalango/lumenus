
local weapons = {
    small = {
        id = "small",
        name = "Small",
        shot = "small",
        shotCount = 1,
        shotSpeed = 100,
        repeatTime = 150,
        
        price = 1000
    },
    
    spread2 = {
        id = "spread2",
        name = "Spread 2",
        shot = "small",
        shotCount = 2,
        shotSpeed = 100,
        repeatTime = 150,
        
        phifn = function(dt,_phi,phi,i,imax)
            return ((2*i-3)*45)
            --return phi + (i-2)*20
        end,
        
        price = 4000
    },
    
    spread3 = {
        id = "spread3",
        name = "Spread 3",
        shot = "small",
        shotCount = 3,
        shotSpeed = 100,
        repeatTime = 150,
        
        phifn = function(dt,_phi,phi,i,imax)
            return ((i-2)*45)
            --return phi + (i-2)*20
        end,
        
        
        price = 8000
    },

    beamer = {
        id = "beamer",
        name = "Beamer",
        shot = "small",
        shotCount = 2,
        shotSpeed = 500,
        repeatTime = 10,
                
        phifn = function(dt,_phi,phi,i,imax)
            return ((2*i-3)*90) * math.sin(2*math.pi*0.01*framecounter)
            --return phi + (i-2)*20
        end,
        
        price = 10000

    },
    
    goLeft = {
        id = "goLeft",
        name = "Go Left",
        shot = "small",
        shotCount = 2,
        shotSpeed = 500,
        repeatTime = 10,
        
        flyfn = function(dt,x,y,dx,dy,speed)
            dx,dy = util.sign(borders.left+10-x), util.sign(-y)
        
            return util.move(dt,x,y,dx,dy,speed)
            --xx = xx + math.sin(2*math.pi*(1/speed)*y + math.pi/1.5)*5 
            
            --xx = xx + 10-(math.random()*20)
            
        end, 
        
        price = 2000

        
    },
    
    goRight = {
        id = "goRight",
        name = "Go Right",
        shot = "small",
        shotCount = 2,
        shotSpeed = 500,
        repeatTime = 10,
        
        flyfn = function(dt,x,y,dx,dy,speed)
            dx,dy = util.sign(borders.right-10-x), util.sign(-y)
        
            return util.move(dt,x,y,dx,dy,speed)
            --xx = xx + math.sin(2*math.pi*(1/speed)*y + math.pi/1.5)*5 
            
            --xx = xx + 10-(math.random()*20)
            
        end, 
        
        price = 2000

        
    },
    
    followMob = {
        id = "followMob",
        name = "Follow",
        shot = "small",
        shotCount = 1,
        shotSpeed = 300,
        repeatTime = 100,
        
        phifn = function(dt,_phi,phi,i,imax,x,y)
            local mob = currentmap:getFirstMob()
            
            if not mob then
                return 0
            end
            
            return math.deg(math.atan2(y-mob.ship.y-50, x-mob.ship.x))-90
        end,
        
        price = 8000
    },
    
    big = {
        id = "big",
        name = "BIG",
        shot = "big",
        shotCount = 10,
        shotSpeed = 500,
        repeatTime = 10,
        
        phifn = function(dt,_phi,phi,i,imax,x,y)
            return ((i-5)*5) * math.sin(2*math.pi*0.01*framecounter)
            --return phi + (i-2)*20
        end,
        
        price = 100000

    }
}

return weapons