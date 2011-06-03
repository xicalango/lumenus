
local Gui = {}
Gui.__index = Gui

function Gui.create(x,y)
    local self = {}
    setmetatable(self,Gui)
    
    self.x = x
    self.y = y

    self.showScore = 0
    
    self.font = love.graphics.newFont(20)
    
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
    linecounter = Gui.print( linecounter, "Score: " .. self.showScore, 10, 10)
    linecounter = Gui.print( linecounter, "Lives: " .. player.lives, 10, 10)
    linecounter = Gui.print( linecounter, "Map Duration: " .. math.ceil(currentmap.playtime), 10, 10)
    
    linecounter = Gui.print( linecounter, "Left Weapon: " .. tostring(player.ship.weapons.left.weapon or ""), 10, 10 )
    linecounter = Gui.print( linecounter, "Center Weapon: " .. tostring(player.ship.weapons.center.weapon or ""), 10, 10 )
    linecounter = Gui.print( linecounter, "Right Weapon: " .. tostring(player.ship.weapons.right.weapon or ""), 10, 10 )
    
    love.graphics.setFont(font)
    love.graphics.setColor(_r,_g,_b,_a)
    love.graphics.pop()
end

function Gui:update(dt)
    if self.showScore ~= player.score then
        self.showScore = self.showScore + 5
        
        if self.showScore > player.score then
            self.showScore = player.score
        end
    end
end

return Gui