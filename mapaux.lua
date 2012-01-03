
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

return Aux
