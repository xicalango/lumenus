
local weapons = {
    small = {
        shot = "small",
        shotCount = 1,
        shotSpeed = 100,
        repeatTime = 100
    },

    beamer = {
        shot = "small",
        shotCount = 2,
        shotSpeed = 500,
        repeatTime = 10,
        
        --[[flyfn = function(dt,x,y,dx,dy,speed)
            local xx,yy = util.move(dt,x,y,dx,dy,speed)
            xx = xx + math.sin(2*math.pi*(1/speed)*y + math.pi/1.5)*5 
            
            --xx = xx + 10-(math.random()*20)
            
            return xx,yy
        end,]] 
        
        phifn = function(dt,_phi,phi,i,imax)
            return ((2*i-3)*90) * math.sin(2*math.pi*0.01*framecounter)
            --return phi + (i-2)*20
        end
    },
    
    goLeft = {
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
        
    },
    
    goRight = {
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
        
    },
    
    big = {
        shot = "big",
        shotCount = 10,
        shotSpeed = 500,
        repeatTime = 10,
        
        phifn = function(dt,_phi,phi,i,imax)
            return ((i-5)*5) * math.sin(2*math.pi*0.01*framecounter)
            --return phi + (i-2)*20
        end
    }
}

return weapons