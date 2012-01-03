local aux = require("mapaux.lua")


local enemiesStack = {"small", "medium", "hard", "vsmallsin", "vhard"}

local enemiesList = {"vsmall"}
local levelDuration = 60


return function(level)
    local Map = aux.newMap("Level " .. tostring(level))
    
    if level % 5 == 0 then
        newEnemy = enemiesStack[1]
        table.remove(enemiesStack,1)
        table.insert(enemiesList, newEnemy)
    end
    
    Map.timeline = {}
    
    if level % 5 == 0 then
        Map.timeline[0] = function(map,ctrl)
            si:displayMessage( "New enemy type!", nil, borders.itemGet + 20, nil, {255,32,32} )
            aux.createRandomEnemiesTimeline(Map, enemiesList, levelDuration)(map,ctrl)
        end
    else
        Map.timeline[0] = aux.createRandomEnemiesTimeline(Map, enemiesList, levelDuration)
    end

    
    if level % 7 == 0 then
        Map.timeline[1] = function(map, ctrl)
        	map:removeGui( Map.gui["time"] )
        	ctrl:removeSchedule("createMonsters")
        end
        Map.timeline[50] = function(map, ctrl)

        end
        Map.timeline[51] = function(map, ctrl)

        end
    else
        Map.timeline[1] = function(map, ctrl)
        	map:removeGui( Map.gui["time"] )
        	ctrl:removeSchedule("createMonsters")
            map:finish()
        end
    end
    
    return Map
end
