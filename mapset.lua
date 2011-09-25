local MapSetManager = {}
MapSetManager.__index = MapSetManager

function MapSetManager.create()
	local self = {}
	setmetatable(self,MapSetManager)
	
	self.mapsets = {}
	self.current = "default"
	
	self:init()
	
	return self
end

function MapSetManager:init()
	local files = love.filesystem.enumerate( "maps" )
	
	for i,v in ipairs(files) do
		local mapset = {}
		
		mapset.path = "maps/" .. v .. "/"
		mapset.maps = {}
		
		for l in love.filesystem.lines(mapset.path .. "maps.lst") do
			table.insert(mapset.maps,l)
		end
		
		self.mapsets[v] = mapset
	end
	
	self.current = "default"
	
end

function MapSetManager:getMap(level)
	local mapset = self.mapsets[self.current]

	if level > #mapset.maps then 
		return nil 
	end

	local mapFile = mapset.path .. mapset.maps[level]
	
	local map = love.filesystem.load(mapFile)()
	
	return map
end


return MapSetManager