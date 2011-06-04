-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

require("util.lua")

Menu = require("menu.lua")

Shot = require("shot.lua")
Weapon = require("weapon.lua")

Map = require("map.lua")

GameState = require("gamestate.lua")
Ship = require("ship.lua")
Player = require("player.lua")

Mob = require("mob.lua")
Drop = require("drop.lua")

--goo = require("goo/goo.lua")
--anim = require("anim/anim.lua")

keyConfig = {
    left = {"a","left"},
    right = {"d","right"},
    up = {"w","up"},
    down = {"s","down"},
    shoot = " ",
    next = "+",
    prev = "-",
    select = "return",
    abort = "escape",
    modifier = {"lshift","rshift"}
}

borders = {
    left = 0,
    right = 500,
    itemGet = 150
}

owner = {
    player = 0,
    enemy = 1
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
    elseif key == "f10" then
        currentmap.playtime = 0
    elseif key =="f11" then
        player:changeScore(100000,player.ship.x,player.ship.y)
    elseif key == "f5" then
        love.graphics.toggleFullscreen()
    elseif key == "0" then
        player.energyRegain = player.energyRegain * 2
    elseif key == "9" then
        player.energyRegain = player.energyRegain / 2
        if player.energyRegain <= 0 then
            player.energyRegain = 1
        end
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

