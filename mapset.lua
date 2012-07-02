-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local MapSetManager = {}
MapSetManager.__index = MapSetManager

function MapSetManager.create()
	local self = {}
	setmetatable(self,MapSetManager)
	
	self.mapsets = {}
	self.current = "random"
	
	self:init()
	
	return self
end

function MapSetManager:init()
	local files = love.filesystem.enumerate( "maps" )
	
	for i,v in ipairs(files) do
		local mapset = {}
		
		mapset.path = "maps/" .. v .. "/"
		
		if love.filesystem.exists( mapset.path .. "maps.lst") then
    		mapset.maps = {}
		    for l in love.filesystem.lines(mapset.path .. "maps.lst") do
			    table.insert(mapset.maps,l)
		    end
		elseif love.filesystem.exists( mapset.path .. "maps.lua") then
		    mapset.mapfn = love.filesystem.load( mapset.path .. "maps.lua" )()
	    end
		
		self.mapsets[v] = mapset
	end
	
	self.current = "random"
	
end

function MapSetManager:setMapset(name)
    self.current = name
end

function MapSetManager:getMap(level)
	local mapset = self.mapsets[self.current]
    
    if mapset.maps then
	    if level > #mapset.maps then 
		    return nil 
	    end

	    local mapFile = mapset.path .. mapset.maps[level]
	
	    local map = love.filesystem.load(mapFile)()
	
	    return map
    elseif mapset.mapfn then
        return mapset.mapfn(level)
    end

end


return MapSetManager
