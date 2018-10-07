local aux = require("mapaux")

local Map = aux.newMap("First Map")

Map.timeline[0] = function(map, ctrl)

	local stopFc = false

	ctrl:addSchedule("createMonsters", math.random()*2, function(map,ctrl)
	    local x = math.random(borders.left,borders.right)
	    
		map:createMob( "vsmall", x, -10, 1 )
		return math.random()+1
	end)
	
	ctrl:addSchedule("randomMonsters", 60, function(_map,_ctrl)
		stopFc = true
	end)
	
	Map.gui["time"] = map:createGui( 
		"textmv", 
		"Time: ", 
		function() return math.ceil(ctrl:getScheduleDelay("randomMonsters")),60 end
		)
	
	ctrl:stopFramecounterUntil(function(dt)
		return stopFc
	end)
	
end

Map.timeline[1] = function(map, ctrl)
	map:removeGui( Map.gui["time"] )
	ctrl:removeSchedule("createMonsters")
	
	si:displayMessage( "Enemy swarm ahead!", nil, nil, nil, {255,0,0} )
end

Map.timeline[50] = function(map,ctrl) 
	local mobs = {}

--[[	table.insert(mobs, map:createMob( "vsmall", 50, -10, 0, Path.create({{150, 100}}) ) )
	table.insert(mobs, map:createMob( "vsmall", 100, -10, 0, Path.create({{100, 150}}) ) )
	table.insert(mobs, map:createMob( "vsmall", 150, -10, 0, Path.create({{50, 100}}) ) )]]

	table.insert(mobs, map:createMob( "vsmall", 200, -10, 0, Path.create({{300, 100}}) ) )
	table.insert(mobs, map:createMob( "vsmall", 250, -10, 0, Path.create({{250, 150}}) ) )
	table.insert(mobs, map:createMob( "vsmall", 300, -10, 0, Path.create({{200, 100}}) ) )
	
--[[	table.insert(mobs, map:createMob( "vsmall", 350, -10, 0, Path.create({{450, 100}}) ) )
	table.insert(mobs, map:createMob( "vsmall", 400, -10, 0, Path.create({{400, 150}}) ) )
	table.insert(mobs, map:createMob( "vsmall", 450, -10, 0, Path.create({{350, 100}}) ) )]]
	
	ctrl:stopFramecounterWhile(aux.mobTableWatcher(mobs))
end

Map.timeline[51] = function(map,ctrl) 
	map:finish()
end


return Map
