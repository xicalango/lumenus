-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local Pause = {}
Pause.__index = Pause

function Pause.load()
    
    Pause.normalFont = love.graphics.newFont(12)
    Pause.font = love.graphics.newFont(48)
    
end

function Pause.draw()

    gamestate:foreignCall("InGame","draw")

    love.graphics.setColor(255,255,255,255)
   
    
    love.graphics.setFont(Pause.font)
    
    local x = (love.graphics:getWidth()/2) - Pause.font:getWidth("GAME OVER!")
    
    love.graphics.print( "PAUSE!", x, love.graphics.getHeight()/2 )
    
    love.graphics.setFont(Pause.normalFont)
    
    x = (love.graphics:getWidth()/2) - love.graphics:getFont():getWidth("Press ESC to resume.")
    
    love.graphics.print( "Press ESC to resume.", x, love.graphics:getHeight()/2 + Pause.font:getHeight() )

end

function Pause.keypressed(key)
    if key == "escape" then
        gamestate:change("InGame")
    end
end



return Pause