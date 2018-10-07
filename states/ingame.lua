-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local Gui = require("gui")
local ScoreIndicator = require("scoreindicator")
local Background = require("background")

local InGame = {}
InGame.__index = InGame

function InGame.load()
	player = Player:create()
    level = 1
	
    --currentmap = Map.create()
    
    InGame.gui = Gui.create(borders.right+1,0)
    
    explosionPS = love.graphics.newParticleSystem(love.graphics.newImage("media/ep.png"), 1000)
    explosionPS:setEmissionRate(100)
	explosionPS:setSpeed(200, 200)
	explosionPS:setLinearAcceleration(0, 0, 0, 0)
	explosionPS:setSizes(1, 1)
	explosionPS:setColors(255, 0, 0, 255, 58, 0, 0, 0)
	explosionPS:setEmitterLifetime(0.1)
	explosionPS:setParticleLifetime(1)
	explosionPS:setDirection(0)
	explosionPS:setSpread(360)
	explosionPS:stop()
    
    damagePS = love.graphics.newParticleSystem(love.graphics.newImage("media/ep.png"), 1000)
    damagePS:setEmissionRate(100)
	damagePS:setSpeed(200, 200)
	damagePS:setLinearAcceleration(0, 0, 0, 0)
	damagePS:setSizes(0.5, 0.5)
	damagePS:setColors(0, 0, 0, 255, 58, 0, 0, 0)
	damagePS:setEmitterLifetime(0.1)
	damagePS:setParticleLifetime(0.5)
	damagePS:setDirection(0)
	damagePS:setSpread(1)
	damagePS:stop()
    
    si = ScoreIndicator.create()
	
	bg = Background.create()
    
    InGame.music = util.map(
        util.filter(love.filesystem.getDirectoryItems("media/music"),
            function(v)
                return not string.match(v, "^_.*")
            end),
            
        function(v)
            return "media/music/" .. v
        end)
    
    TEsound.volume("music",.3)
end

function InGame.onStateChange(oldstate)
    if oldstate == "Shop" then
        level = level + 1

        newMap = msm:getMap(level)

		if newMap == nil then
			gamestate:change("GameOver")
			return false
		end
		
        currentmap = Map.create(newMap,InGame.gui)

        player:reset()
        
        InGame.gui.showScore = player.score
        
        si:reset()
        
        si:displayMessage( currentmap.name )

        return true
    elseif oldstate == "GameOver" or oldstate == "MainMenu" then
        player = Player.create()
        player.ship.y = 500
        player.ship.x = (borders.right-borders.left)/2
        
		player.ship:mountWeapon("center","small")
		
        level = 1
	
		currentmap = Map.create(msm:getMap(level),InGame.gui)
        
        explosionPS:stop()
        damagePS:stop()

        InGame.gui.showScore = player.score
        
        TEsound.stop("music")
        InGame.musicChannel = nil
        
        si:reset()

        si:displayMessage( currentmap.name )

    end
    
    return true
end

function InGame.onActivation()
    TEsound.cleanup()
    love.mouse.setVisible(false)

    player:stop()
    
    if InGame.musicChannel == nil then
        TEsound.playLooping(InGame.music,"music")
        InGame.musicChannel = true
    else
        TEsound.resume("music")
    end
end

function InGame.onDeactivation()
	love.graphics.setBackgroundColor( 0, 0, 0 )
    TEsound.pause("music")
end

function InGame.update(dt)
    player:update(dt)
    currentmap:update(dt)
    
    InGame.gui:update(dt)
    
    explosionPS:update(dt)
    damagePS:update(dt)
    
    si:update(dt)
	
	bg:update(dt)
end

function InGame.draw()
	bg:draw()
    si:draw()

    player:draw()
    currentmap:draw()

    InGame.gui:draw()
    
    love.graphics.draw(explosionPS,0,0)
    love.graphics.draw(damagePS,0,0)
    
    love.graphics.line(borders.left,0,borders.left,600)
    love.graphics.line(borders.right,0,borders.right,600)
--[[ 
    if player.mod then
        love.graphics.setColor( 0,255,255, 32 )
        love.graphics.line(borders.left,borders.itemGet, borders.right,borders.itemGet)
        love.graphics.setColor( 255,255,255 )
    end
]]

end

function InGame.keypressed(key)
    if key == "escape" then
        gamestate:change("Pause")
    elseif key == "f2" then
        gamestate:change("GameOver")
    end

    player:keypressed(key)
end

function InGame.keyreleased(key)
    player:keyreleased(key)
end

function InGame.mousepressed(x,y,button)
	print(x,y)
end


return InGame
