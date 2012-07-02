-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

--local util = require("util.lua")

local Aux = {}
Aux.__index = Aux

function Aux.newMap(name, music)
    local Map = {}
    
    Map.name = name
    Map.music = music

    Map.timeline = {}

    Map.gui = {}
    
    return Map
end

function Aux.mobTableWatcher(mobs)
	return function(dt)
		local continue = false
		
		for i,v in ipairs(mobs) do
			if v.state == Mob.States.FLY then
				continue = true
				break
			end
		end
		
		return continue
	end
end

function Aux.deathGoto(framecounter)
	return function(map,ctrl) 
		ctrl:goto(framecounter) 
		ctrl:start()
	end
end

function Aux.createRandomEnemiesTimeline(Map, enemiesList, levelDuration, delay)
    delay = delay or 1

    return function(map,ctrl)
        local stopFc = false

	    ctrl:addSchedule("createMonsters", math.random()*2, function(map,ctrl)
	        local x = math.random(borders.left,borders.right)
	        
		    map:createMob( util.takeRandom(enemiesList), x, -10, 1 )
		    return math.random()+delay
	    end)
	
	    ctrl:addSchedule("randomMonsters", levelDuration, function(_map,_ctrl)
		    stopFc = true
	    end)
	
	    Map.gui["time"] = map:createGui( 
		    "textmv", 
		    "Time: ", 
		    function() return math.ceil(ctrl:getScheduleDelay("randomMonsters")),levelDuration end
		    )
	
	    ctrl:stopFramecounterUntil(function(dt)
		    return stopFc
	    end)

    end
end


return Aux
