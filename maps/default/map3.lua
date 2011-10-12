local Map = {}

Map.name = "Endless map"
Map.music = nil

Map.timeline = {}

Map.timeline.init = function(ctrl)

	ctrl:addSchedule("createMonsters", math.random()*2, function(map,ctrl)
		map:createMob( "vsmall", math.random(borders.left,borders.right), -10, 1 )
		return math.random()+1
	end)
	
	ctrl:addSchedule("endLevel", 90, function(map,ctrl)
		map:finish()
	end)
end

return Map
