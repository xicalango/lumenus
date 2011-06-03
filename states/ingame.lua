-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

Gui = require("gui.lua")

local InGame = {}
InGame.__index = InGame

function InGame.load()
    player = Player.create()
    player.ship.y = 500
    player.ship.x = (borders.right-borders.left)/2
    
    level = 1
    
    currentmap = Map.create()
    
    InGame.gui = Gui.create(borders.right+1,0)
end

function InGame.onStateChange(oldstate)
    if oldstate == "Shop" then
        level = level + 1
        
        if level == 3 then
            table.insert(currentmap.enemyTypes, "medium")
        end

        if level == 6 then
            table.insert(currentmap.enemyTypes, "hard")
        end
        
        if level == 12 then
            table.insert(currentmap.enemyTypes, "vhard")
        end

        return true
        
    end
    
    return true
end

function InGame.onActivation()
    love.mouse.setVisible(false)
    
    player.invincible = true
    player.invincibleTimer = 3

    currentmap:reset()

    player.ship.y = 500
    player.ship.x = (borders.right-borders.left)/2
    
    player.ship.dx = 0
    player.ship.dy = 0
    player.fireTrigger = false
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