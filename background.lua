
local Background = {}
Background.__index = Background

local config = {
	minVelocity = 50,
	maxVelocity = 100,
	
	numStars = 30,
	starProb = 0.1,
	
	graphics = {
		{ 	image = love.graphics.newImage( "media/p1x1.png"),
			offset = {0,0}
		},
		{ 	image = love.graphics.newImage( "media/p2x2.png"),
			offset = {1,1}
		},
	}
}

function Background.create()
	local self = {}
	setmetatable(self,Background)
	
	self.objects = {}

	for i = 1,config.numStars do
		self:createStar(0,600)
	end
	
	return self
end

function Background:createStar(fromY,toY)
	fromY = fromY or -200
	toY = toY or 0
	local newStar = {}
	
	newStar.x = math.random(borders.left,borders.right)
	newStar.y = math.random(fromY,toY)
	
	newStar.graphics = util.takeRandom(config.graphics)
	
	newStar.velocity = math.random(config.minVelocity,config.maxVelocity)
	
	table.insert(self.objects, newStar)
end

function Background:update(dt)
	for i,s in ipairs(self.objects) do
		s.x, s.y = util.move( dt, s.x, s.y, 0, 1, 0, s.velocity )
		
		if s.y > 620 then
			table.remove(self.objects,i)
		end
	end
	
	if math.random() < config.starProb then
		self:createStar()
	end
end

function Background:draw()
	for i,s in ipairs(self.objects) do
		util.drawGraphic( s.graphics, s.x, s.y )
	end
end


return Background
