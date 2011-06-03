
local weapons = {
    small = {
        id = "small",
        name = "Small",
        shot = "small",
        shotCount = 1,
        shotSpeed = 200,
        repeatTime = 150,
        
        price = 1000,
        
        energy = 5
    },
    
    smallfast = {
        id = "smallfast",
        name = "Small Fast",
        shot = "lineb",
        shotCount = 1,
        shotSpeed = 300,
        repeatTime = 150,
        
        price = 1500,
        
        energy = 7
    },
    
    sinus = {
        id = "sinus",
        name = "Sinus",
        shot = "line",
        shotCount = 1,
        shotSpeed = 300,
        repeatTime = 50,
        
        price = 3000,
        
        energy = 10,
        
        flyfn = function(dt,x,y,dx,dy,speed)
            local xx,yy = util.move(dt,x,y,dx,dy,speed)
            
            return xx + math.sin(2*math.pi*0.005*y)*2, yy
        end
    },
    
    spread2 = {
        id = "spread2",
        name = "Spread 2",
        shot = "line",
        shotCount = 2,
        shotSpeed = 200,
        repeatTime = 150,
        
        phifn = function(dt,_phi,phi,i,imax,x,y,modifier)
            if modifier then
                return ((2*i-3)*5)
            else
                return ((2*i-3)*30)
            end
            --return phi + (i-2)*20
        end,
        
        price = 4000,
        energy = 10
    },
    
    spread3 = {
        id = "spread3",
        name = "Spread 3",
        shot = "line",
        shotCount = 3,
        shotSpeed = 200,
        repeatTime = 150,
        
        phifn = function(dt,_phi,phi,i,imax,x,y,modifier)
            if modifier then
                return ((i-2)*5)
            else
                return ((i-2)*30)
            end
            --return phi + (i-2)*20
        end,
        
        
        price = 8000,
        
        energy = 15

    },

    beamer = {
        id = "beamer",
        name = "Beamer",
        shot = "small",
        shotCount = 2,
        shotSpeed = 500,
        repeatTime = 10,
                
        phifn = function(dt,_phi,phi,i,imax,x,y,modifier)
            if modifier then
                return ((2*i-3)*35) * math.sin(2*math.pi*0.01*framecounter)
            else
                return ((2*i-3)*80) * math.sin(2*math.pi*0.01*framecounter)
            end
            --return phi + (i-2)*20
        end,
        
        price = 10000,
        energy = 20

    },
    
   
    followMob = {
        id = "followMob",
        name = "Follow",
        shot = "lineb",
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
        
        price = 8000,
        energy = 10
    },
    
    big = {
        id = "big",
        name = "BIG",
        shot = "big",
        shotCount = 10,
        shotSpeed = 500,
        repeatTime = 10,
        
        phifn = function(dt,_phi,phi,i,imax,x,y,modifier)
            if modifier then
                return ((i-5)*2.5) * math.sin(2*math.pi*0.05*framecounter)
            else
                return ((i-5)*5) * math.sin(2*math.pi*0.01*framecounter)
            end
        
            --return phi + (i-2)*20
        end,
        
        price = 100000,
        
        rspeed = 100,
        energy = 30

    }
}

return weapons