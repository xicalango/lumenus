local aux = require("mapaux")

local Map = aux.newMap("Second Map")


Map.timeline[100] = function(map,ctrl) 
	map:createMob( "vsmall", 10, -10, 1 )
	map:createMob( "vsmall", 110, -10, 1 )
end

Map.timeline[200] = function(map,ctrl) 
	local boss = map:createMob( "vsmall", 250, 0, 0 )
	local mobCreation = math.random()*2
	
	ctrl:stopFramecounterUntil(function(dt)
	
		ctrl:addSchedule("createMonsters", math.random()*2, function(map,ctrl)
			map:createMob( "vsmall", math.random(borders.left,borders.right), -10, 1 )
			return math.random()+1
		end)
	
		mobCreation = mobCreation - dt
	
		return boss.state == Mob.States.DIE
	end)
	
end

Map.timeline[201] = function(map,ctrl) 
	map:finish()
end

return Map
