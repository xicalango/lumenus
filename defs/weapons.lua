-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local weapons = {
    small = {
        name = "Small",
        shot = "small",
        shotCount = 1,
        shotSpeed = 200,
        repeatTime = 150,
        
        price = 2000,
        
        energy = 50,
        
        upgrade = "smallfast",
        
        sound = "laser",
    },
    
    smallfast = {
        name = "Small Fast",
        shot = "lineb",
        shotCount = 1,
        shotSpeed = 300,
        repeatTime = 150,
        
        price = 5000,
        
        energy = 70,
        
        notInShop = true,
        upgrade = "smallfastplus",
        sound = "laser1",

    },
    
    random = {
    	name = "Random Gun",
    	shot = "small",
    	shotCount = 1,
    	shotSpeed = 400,
    	repeatTime = 150,
    	
    	price = 5000,
    	
    	energy = 70,
    	
        phifn = function(dt,_phi,phi,i,imax,x,y,modifier)
            if modifier then
                return 20 * (math.random()-0.5)
            else
                return 60 * (math.random()-0.5)
            end
            --return phi + (i-2)*20
        end,
        
        sound = "laser1",
 
    },
    
    gravity = {
    	name = "Gravity Gun",
    	shot = "small",
    	shotCount = 1,
    	shotSpeed = 700,
    	repeatTime = 150,
    	
    	price = 5000,
    	
    	energy = 70,
        
        upgrade = "gravitySplit",
        
        sound = "laser1",
    	
        flyfn = function(dt,x,y,dx,dy,speed,dummy,self)
            self.dy = self.dy + dt
            local xx,yy = util.move(dt,x,y,dx,dy,speed)
            
            return xx, yy
        end,
        phifn = function(dt,_phi,phi,i,imax,x,y,modifier)
            if modifier then
                return 10 * math.sin(2*math.pi*0.01*framecounter)
            else
                return 20 * math.sin(2*math.pi*0.01*framecounter)
            end
            --return phi + (i-2)*20
        end,
        

 
    },

    gravitySplit = {
    	name = "Gravity Split Gun",
    	shot = "small",
    	shotCount = 1,
    	shotSpeed = 300,
    	repeatTime = 150,
    	
    	price = 5000,
    	
    	energy = 70,
        
        notInShop=true,
        upgrade = "gravitySplitPlus",
        
        sound = "laser1",
    	
        flyfn = function(dt,x,y,dx,dy,speed,dummy,self)

            self.dy = self.dy + dt
            local xx,yy = util.move(dt,x,y,dx,dy,speed)
            
            if self.dy >= 0 then
            	self.state = 1 -- DIE
            	currentmap:createShot( "small", x, y, -30, speed, self.owner )
            	currentmap:createShot( "small", x, y,  30, speed, self.owner )
            end
            
            return xx, yy
        end,
        phifn = function(dt,_phi,phi,i,imax,x,y,modifier)
            if modifier then
                return 10 * math.sin(2*math.pi*0.01*framecounter)
            else
                return 20 * math.sin(2*math.pi*0.01*framecounter)
            end
            --return phi + (i-2)*20
        end,
 
 
    },
    
    gravitySplitPlus = {
    	name = "Gravity Split +",
    	shot = "line",
    	shotCount = 1,
    	shotSpeed = 300,
    	repeatTime = 150,
    	
    	price = 5000,
    	
    	energy = 70,
        
        notInShop=true,
        
        sound = "laser1",
    	
        flyfn = function(dt,x,y,dx,dy,speed,dummy,self)

            self.dy = self.dy + dt
            local xx,yy = util.move(dt,x,y,dx,dy,speed)
            
            if self.dy >= 0 then
            	self.state = 1 -- DIE
            	currentmap:createShot( "lineb", x, y, -30, speed, self.owner )
            	currentmap:createShot( "lineb", x, y,  30, speed, self.owner )
            end
            
            return xx, yy
        end,
        phifn = function(dt,_phi,phi,i,imax,x,y,modifier)
            if modifier then
                return 10 * math.sin(2*math.pi*0.01*framecounter)
            else
                return 20 * math.sin(2*math.pi*0.01*framecounter)
            end
            --return phi + (i-2)*20
        end,
 
 
    },

    
    smallfastplus = {
        name = "Small Fast +",
        shot = "line",
        shotCount = 1,
        shotSpeed = 300,
        repeatTime = 150,
        
        price = 8000,
        
        energy = 100,
        
        sound = "laser1",
        
        notInShop = true
    },
    
    vulcan1 = {
        name = "Vulcan 1",
        shot = "vulcan",
        shotCount = 1,
        shotSpeed = 500,
        repeatTime = 50,
        
        price = 50000,
        
        energy = 30,
        
        upgrade = "vulcan2"
    },
    
    vulcan2 = {
        name = "Vulcan 2",
        shot = "vulcan",
        shotCount = 1,
        shotSpeed = 500,
        repeatTime = 30,
        
        price = 50000,
        
        energy = 30,
        
        notInShop =true,
        
        upgrade = "vulcan3"
    },
    
    vulcan3 = {
        name = "Vulcan 3",
        shot = "vulcan",
        shotCount = 1,
        shotSpeed = 500,
        repeatTime = 10,
        
        price = 50000,
        
        energy = 30,
        
        notInShop = true
    },
    
    sinus = {
        name = "Sinus",
        shot = "lineb",
        shotCount = 1,
        shotSpeed = 300,
        repeatTime = 50,
        
        price = 9000,
        
        energy = 10,
        
        sound = "laser1",
        
        flyfn = function(dt,x,y,dx,dy,speed)
            local xx,yy = util.move(dt,x,y,dx,dy,speed)
            
            return xx + math.sin(2*math.pi*0.005*y)*2, yy
        end,
		
		upgrade = "sinusPlus"
    },
     
    sinusPlus = {
        name = "Sinus Plus",
        shot = "lineb",
        shotCount = 2,
        shotSpeed = 300,
        repeatTime = 50,
        
        price = 9000,
        
        energy = 30,
        
        flyfn = function(dt,x,y,dx,dy,speed, speedy, self)
            local xx,yy = util.move(dt,x,y,dx,dy,speed)
            
            return xx + math.sin(2*math.pi*0.005*y  -  (2*math.pi*(self.i-1)/2) )*3, yy
        end,
		
		upgrade = "sinusPlusPlus",
		
		notInShop = true
    },
	
	sinusPlusPlus = {
        name = "Sinus++",
        shot = "lineb",
        shotCount = 3,
        shotSpeed = 300,
        repeatTime = 50,
        
        price = 9000,
        
        energy = 50,
        
        flyfn = function(dt,x,y,dx,dy,speed, speedy, self)
            local xx,yy = util.move(dt,x,y,dx,dy,speed)
            
            return xx + math.sin(2*math.pi*0.005*y  -  (2*math.pi*(self.i-1)/3) )*3, yy
        end,
		
		upgrade = "sinusSharp",
		
		notInShop = true
    },
	
	sinusSharp = {
        name = "Sinus#",
        shot = "lineb",
        shotCount = 4,
        shotSpeed = 300,
        repeatTime = 50,
        
        price = 9000,
        
        energy = 100,
        
        flyfn = function(dt,x,y,dx,dy,speed, speedy, self)
            local xx,yy = util.move(dt,x,y,dx,dy,speed)
            
            return xx + math.sin(2*math.pi*0.005*y  -  (2*math.pi*(self.i-1)/4) )*3, yy
        end,
		
		
		notInShop = true
    },
    
    --[[sinus2 = {
        name = "Sinus 2",
        shot = "lineb",
        shotCount = 1,
        shotSpeed = 300,
        repeatTime = 50,
        
        price = 9000,
        
        energy = 10,
        
        sound = "laser1",
        
        flyfn = function(dt,x,y,dx,dy,speed)
            local xx,yy = util.move(dt,x,y,dx,dy,speed)
            
            return xx + math.sin(2*math.pi*0.01*framecounter)*2, yy
        end
    },
    
    sinus2Plus = {
        name = "Sinus 2 Plus",
        shot = "lineb",
        shotCount = 2,
        shotSpeed = 300,
        repeatTime = 50,
        
        price = 9000,

        
        energy = 10,
        
        flyfn = function(dt,x,y,dx,dy,speed,speedy,self)
            local xx,yy = util.move(dt,x,y,dx,dy,speed)
            
            local fn = math.sin
            
            if self.i == 2 then
            	fn = math.cos
            end
            
            return xx + fn(2*math.pi*0.01*framecounter)*3, yy
        end
    },]]
    
    spread2 = {
        name = "Spread 2",
        shot = "lineb",
        shotCount = 2,
        shotSpeed = 200,
        repeatTime = 150,
        
        sound = "laser1",
        
        phifn = function(dt,_phi,phi,i,imax,x,y,modifier)
            if modifier then
                return ((2*i-3)*5)
            else
                return ((2*i-3)*30)
            end
            --return phi + (i-2)*20
        end,
        
        price = 8000,
        energy = 50,
        
        upgrade = "spread2plus"
    },
    
    spread3 = {
        name = "Spread 3",
        shot = "lineb",
        shotCount = 3,
        shotSpeed = 200,
        repeatTime = 150,
        
        sound = "laser1",
        
        phifn = function(dt,_phi,phi,i,imax,x,y,modifier)
            if modifier then
                return ((i-2)*5)
            else
                return ((i-2)*30)
            end
            --return phi + (i-2)*20
        end,
        
        
        price = 16000,
        
        energy = 50,
        
        upgrade = "spread3plus"

    },
    
    spread2plus = {
        name = "Spread 2 +",
        shot = "line",
        shotCount = 2,
        shotSpeed = 200,
        repeatTime = 150,
        
        sound = "laser1",
        
        phifn = function(dt,_phi,phi,i,imax,x,y,modifier)
            if modifier then
                return ((2*i-3)*5)
            else
                return ((2*i-3)*30)
            end
            --return phi + (i-2)*20
        end,
        
        price = 20000,
        energy = 100,
        
        notInShop = true,
    },
    
    spread3plus = {
        name = "Spread 3 +",
        shot = "line",
        shotCount = 3,
        shotSpeed = 200,
        repeatTime = 150,
        
        sound = "laser1",
        
        phifn = function(dt,_phi,phi,i,imax,x,y,modifier)
            if modifier then
                return ((i-2)*5)
            else
                return ((i-2)*30)
            end
            --return phi + (i-2)*20
        end,
        
        
        price = 40000,
        
        energy = 100,
        
        notInShop = true

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
        
        price = 50000,
        energy = 20

    },
    
   
    followMob = {
        name = "Follow",
        shot = "lineb",
        shotCount = 1,
        shotSpeed = 300,
        repeatTime = 100,
        
        sound = "laser1",
        
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
        
        price = 500000,
        
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
        
        energy = 500,
        
        sound = "biglaser"
    }
}

return weapons
