
local Gui = {}
Gui.__index = Gui

function Gui.create(x,y)
    local self = {}
    setmetatable(self,Gui)
    
    self.x = x
    self.y = y

    self.showScore = 0
    
    self.font = love.graphics.newFont(20)
    
    self.multiplier = {
        font = love.graphics.newFont(48),
        framebuffer = love.graphics.newFramebuffer( 100, 50 ),
        lifetime = 0
    }
    
    return self
end

function Gui.print(linecounter, text, x, y, r, sx, sy )
    local font = love.graphics.getFont()
    love.graphics.print( text, x, y + linecounter * font:getHeight(), r, sx, sy )
    return linecounter + 1
end

function Gui:draw()
    love.graphics.push()
    love.graphics.translate(self.x,self.y)
    local _r,_g,_b,_a = love.graphics.getColor()
    local font = love.graphics.getFont()
    
    love.graphics.setFont(self.font)
    
    local linecounter = 0
    
    linecounter = Gui.print( linecounter, "Level: " .. level, 10, 10)
    linecounter = Gui.print( linecounter, "Score: " .. math.floor(self.showScore), 10, 10)
    linecounter = Gui.print( linecounter, "Lives: " .. player.lives, 10, 10)

    linecounter = Gui.print( linecounter, "Energy:", 10, 10)
    
    local regain = player.energyRegain
    
    if player.mod then
        regain = regain * 1.1
    end
    
    local y = (linecounter * self.font:getHeight())+self.font:getHeight()*2/3
    
    love.graphics.setColor( 255 - (player.energy/player.maxEnergy) * 255, (player.energy/player.maxEnergy) * 255, 0 )
    
    love.graphics.rectangle( "fill", 10, y, (player.energy/player.maxEnergy) * 200, self.font:getHeight()/2 )
    
    linecounter = Gui.print( linecounter, "", 10, 10)
    
    love.graphics.setColor( 255, 255, 255 )
    
    linecounter = Gui.print( linecounter, "Level Duration: " .. math.ceil(currentmap.playtime), 10, 10)
    
    linecounter = Gui.print( linecounter, "Left Weapon: " .. tostring(player.ship.weapons.left.weapon or ""), 10, 10 )
    linecounter = Gui.print( linecounter, "Center Weapon: " .. tostring(player.ship.weapons.center.weapon or ""), 10, 10 )
    linecounter = Gui.print( linecounter, "Right Weapon: " .. tostring(player.ship.weapons.right.weapon or ""), 10, 10 )
    
    love.graphics.setFont(font)
    love.graphics.setColor(_r,_g,_b,_a)
    love.graphics.pop()
    
    if player.scoreMultiplier.mult > 1 then
    
        love.graphics.draw(self.multiplier.framebuffer, love.graphics.getWidth()/2 - 100, 0, 0,        player.scoreMultiplier.duration/2, nil, 50, 0)
    end
end

function Gui:update(dt)
    if self.showScore ~= player.score then
        local ds = player.score - self.showScore
        if ds > 0 then
            self.showScore = self.showScore + (ds/10)+1
            
            if self.showScore > player.score then
                self.showScore = player.score
            end
        else
            self.showScore = player.score
        end
    end
    
    if player.scoreMultiplier.changed then
        player.scoreMultiplier.changed = false
        
        if player.scoreMultiplier.mult > 1 then
        
            self.multiplier.framebuffer:renderTo(function()
                local font = love.graphics.getFont()
                love.graphics.setFont(self.multiplier.font)
                love.graphics.print( player.scoreMultiplier.mult .. "X", 0, 0 )
                love.graphics.setFont(font)
            end)
        
        end
    end
end

return Gui