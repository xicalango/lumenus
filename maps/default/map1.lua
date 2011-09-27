local Map = {}

local var = 0

Map.name = "First map"
Map.music = nil

Map.timeline = {}

Map.timeline[0] = function(map,ctrl)
	ctrl:addSchedule("counter", 1, function(map,ctrl)
		var = var + 1
		print(ctrl.framecounter, var, ctrl.framecounter/var)
		return 1
	end)
end

Map.timeline[100] = function(map,ctrl) 
	map:createMob( "vsmall", 10, -10, 1 )
	map:createMob( "vsmall", 110, -10, 1 )
end

Map.timeline[150] = function(map,ctrl)
	map:createMob( "vsmall", 210, -10, 1 )
	map:createMob( "vsmall", 310, -10, 1 )
end

Map.timeline[2700] = function(map,ctrl) 
	local boss = map:createMob( "vhard", 250, 10, 0 )
	
	Map.timeline.onPlayerDeath = function(map,ctrl) 
		ctrl:goto(200) 
		ctrl:start()
	end

	ctrl:addSchedule("createMonsters", math.random()*2, function(map,ctrl)
		map:createMob( "vsmall", math.random(borders.left,borders.right), -10, 1 )
		return math.random()+1
	end)
	
	ctrl:stopFramecounterUntil(function(dt)
		return boss.state == Mob.States.DIE
	end)
	
end

Map.timeline[2701] = function(map,ctrl) 
	map:finish()
end

return Map
