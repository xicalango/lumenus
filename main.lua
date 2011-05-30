-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

require("util.lua")

Shot = require("shot.lua")
Weapon = require("weapon.lua")

Map = require("map.lua")

GameState = require("gamestate.lua")
Ship = require("ship.lua")
Player = require("player.lua")


goo = require("goo/goo.lua")
anim = require("anim/anim.lua")

keyConfig = {
    left = {"a","left"},
    right = {"d","right"},
    up = {"w","up"},
    down = {"s","down"},
    shoot = " ",
    next = "+",
    prev = "-"
}

borders = {
    left = 0,
    right = 600
}

function loadDefs()

end

function love.load()
    local states = require("states/states.lua")
    
    gamestate = GameState.create(states)
    
    gamestate:change("InGame")
    
    oldmousex = love.mouse.getX()
    oldmousey = love.mouse.getY()
    
    love.graphics.setBlendMode("alpha")    
    love.graphics.setLineStyle("rough")
    love.graphics.setColorMode("modulate")
    
    shots = {}
    
    framecounter = 0
end

function love.draw()
    love.graphics.clear( )
    
    gamestate:draw()
end

function love.update(dt)
    framecounter = framecounter + 1

    mousedx = oldmousex - love.mouse.getX()
    mousedy = oldmousey - love.mouse.getY()
    oldmousex = love.mouse.getX()
    oldmousey = love.mouse.getY()

    gamestate:update(dt) 
end


function love.keypressed(key)

    if key == "f12" then
		love.event.push("q")
        return
	end
    
    gamestate:keypressed(key)
    
end

function love.keyreleased(key)
    gamestate:keyreleased(key)
end

function love.mousepressed(x, y, button)
    gamestate:mousepressed(x,y,button)
end

function love.mousereleased(x, y, button)
    gamestate:mousereleased(x,y,button)
end

