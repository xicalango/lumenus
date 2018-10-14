-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

require("util")

Menu = require("menu")

Shot = require("shot")
Weapon = require("weapon")

Map = require("map")

GameState = require("gamestate")
Ship = require("ship")
Player = require("player")

Mob = require("mob")
Drop = require("drop")

MapsetManager = require("mapset")

Path = require("path")

require("lib/TEsound")

scaled = false

--goo = require("goo/goo")
--anim = require("anim/anim")

keyConfig = {
    left = {"a","left"},
    right = {"d","right"},
    up = {"w","up"},
    down = {"s","down"},
    shoot = "space",
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

--[[wavetable = {
    explosion = "media/sounds/explosion.wav",
    junk = "media/sounds/collect.ogg",
    laser1 = "media/sounds/laser1.wav",
    playerExplosion = "media/sounds/playerExplosion.wav",
    beep = "media/sounds/beep.wav",
    rat = "media/sounds/rat.wav",
    biglaser = "media/sounds/biglaser.ogg",
}]]

function buildWavetable()
    wavetable = {}

    local function insertWave(name,filename)
        if wavetable[name] == nil then
            wavetable[name] = "media/sounds/"..filename
        else
            local value = wavetable[name] 
            wavetable[name] = {}
            table.insert(wavetable[name],value)
            table.insert(wavetable[name],"media/sounds/"..filename)
        end
    end
    
    local soundfiles = love.filesystem.getDirectoryItems("media/sounds")
    

    
    for i,filename in ipairs(soundfiles) do
        string.gsub(filename, "^(%a+)(%d*)%.(%w+)$", 
            function(name,number,ext)
                
                insertWave(name,filename)
                
                if #number > 0 then
                    insertWave(name..number,filename)
                end
            
                
            end)
    end
end

function love.load()

    local states = require("states/states")
    
    buildWavetable()
    
  	msm = MapsetManager.create()
    
    gamestate = GameState.create(states)
    
    gamestate:change("MainMenu")
    
    oldmousex = love.mouse.getX()
    oldmousey = love.mouse.getY()
    
    love.graphics.setBlendMode("alpha")    
    love.graphics.setLineStyle("rough")
    
    shots = {}
    
    framecounter = 0
	

end

function love.draw()
    love.graphics.clear()
    
    if scaled then
    	love.graphics.scale(.8, .8)
    end
    
    gamestate:draw()
end

function love.update(dt)
    framecounter = framecounter + 1

    mousedx = oldmousex - love.mouse.getX()
    mousedy = oldmousey - love.mouse.getY()
    oldmousex = love.mouse.getX()
    oldmousey = love.mouse.getY()

    gamestate:update(dt) 
    
    TEsound.cleanup()
end


function love.keypressed(key)

    if key == "f12" then
		love.event.push("quit")
        return
    elseif key == "f10" then
	gamestate:change("Shop")    
    elseif key =="f9" then
        player:changeScore(100000,player.ship.x,player.ship.y)
    elseif key == "f5" then
        love.window.setFullscreen( not love.window.getFullscreen(), "exclusive" )
	elseif key == "f6" then
		love.mouse.setVisible(not love.mouse.isVisible())
    elseif key == "m" then
        TEsound.volume("music",0)
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

