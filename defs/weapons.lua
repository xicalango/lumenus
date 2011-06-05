
local weapons = {
    small = {
        name = "Small",
        shot = "small",
        shotCount = 1,
        shotSpeed = 200,
        repeatTime = 150,
        
        price = 1000,
        
        energy = 50
    },
    
    smallfast = {
        name = "Small Fast",
        shot = "lineb",
        shotCount = 1,
        shotSpeed = 300,
        repeatTime = 150,
        
        price = 1500,
        
        energy = 70
    },
    
    smallfastplus = {
        name = "Small Fast +",
        shot = "line",
        shotCount = 1,
        shotSpeed = 300,
        repeatTime = 150,
        
        price = 4500,
        
        energy = 100
    },
    
    vulcan = {
        name = "Vulcan",
        shot = "vulcan",
        shotCount = 1,
        shotSpeed = 500,
        repeatTime = 10,
        
        price = 5000,
        
        energy = 30
    },
    
    sinus = {
        name = "Sinus",
        shot = "lineb",
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
    
    sinus2 = {
        name = "Sinus 2",
        shot = "lineb",
        shotCount = 1,
        shotSpeed = 300,
        repeatTime = 50,
        
        price = 3000,
        
        energy = 10,
        
        flyfn = function(dt,x,y,dx,dy,speed)
            local xx,yy = util.move(dt,x,y,dx,dy,speed)
            
            return xx + math.sin(2*math.pi*0.01*framecounter)*2, yy
        end
    },
    
    spread2 = {
        name = "Spread 2",
        shot = "lineb",
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
        energy = 50
    },
    
    spread3 = {
        name = "Spread 3",
        shot = "lineb",
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
        
        energy = 50

    },
    
    spread2plus = {
        name = "Spread 2 +",
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
        
        price = 12000,
        energy = 100
    },
    
    spread3plus = {
        name = "Spread 3 +",
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
        
        
        price = 16000,
        
        energy = 100

    },

    beamer = {
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

    },
    
    circle = {
        name = "Circle",
        shot = "big",
        shotCount = 10,
        shotSpeed = 500,
        repeatTime = 10,
        
        phifn = function(dt,_phi,phi,i,imax,x,y,modifier)
            if modifier then
                return ((i-5)*2.5)
            else
                return ((i-5)*5)
            end
        
            --return phi + (i-2)*20
        end,
        
        price = 100000,
        
        rspeed = 100,
        energy = 30

    },
    
    wumm = {
        name = "Wumm",
        shot = "vbig",
        shotCount = 1,
        shotSpeed = 200,
        repeatTime = 500,
        
        price = 8000,
        
        energy = 500
    }
}

return weapons