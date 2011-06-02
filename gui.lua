
local Gui = {}
Gui.__index = Gui

function Gui.create(x,y)
    local self = {}
    setmetatable(self,Gui)
    
    self.x = x
    self.y = y

    self.showScore = 0
    
    self.font = love.graphics.newFont(24)
    
    return self
end

function Gui:draw()
    love.graphics.push()
    love.graphics.translate(self.x,self.y)
    local _r,_g,_b,_a = love.graphics.getColor()
    local font = love.graphics.getFont()
    
    love.graphics.setFont(self.font)
    
    love.graphics.print( "Score: " .. self.showScore, 10, 10)
    
    love.graphics.setFont(font)
    love.graphics.setColor(_r,_g,_b,_a)
    love.graphics.pop()
end

function Gui:update(dt)
    if self.showScore < player.score then
        self.showScore = self.showScore + 2
        
        if self.showScore > player.score then
            self.showScore = player.score
        end
    end
end

return Gui