-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

Gui = require("gui.lua")

local InGame = {}
InGame.__index = InGame

function InGame.load()
    player = Player.create()
    player.ship.y = 500
    player.ship.x = (borders.right-borders.left)/2
    
    currentmap = Map.create()
    
    InGame.gui = Gui.create(borders.right+1,0)
    
end

function InGame.onActivation()
    love.mouse.setVisible(false)
end

function InGame.update(dt)
    player:update(dt)
    currentmap:update(dt)
    
    InGame.gui:update(dt)
end

function InGame.draw()
    player:draw()
    currentmap:draw()

    InGame.gui:draw()
    
    love.graphics.line(borders.left,0,borders.left,600)
    love.graphics.line(borders.right,0,borders.right,600)

end

function InGame.keypressed(key)
    player:keypressed(key)
end

function InGame.keyreleased(key)
    player:keyreleased(key)
end


return InGame