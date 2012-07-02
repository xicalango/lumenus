-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local FBMultiplierDisplay = {}
FBMultiplierDisplay.__index = FBMultiplierDisplay

function FBMultiplierDisplay.create()
    local self = {}
    setmetatable(self, FBMultiplierDisplay)

    self.font = love.graphics.newFont(48)
    self.framebuffer = love.graphics.newFramebuffer( 100, 100 )
    self.x = 0
    self.y = 0

    return self
end

function FBMultiplierDisplay:draw()
    if player.scoreMultiplier.mult > 1 then
        love.graphics.setColor( 0,255,255 )    
        love.graphics.draw(self.framebuffer, self.x, self.y, 0, player.scoreMultiplier.duration/2, nil, 50, 50)
        love.graphics.setColor( 255, 255, 255 )
    end
end

function FBMultiplierDisplay:set(x,y)
        self.framebuffer:renderTo(function()
            local font = love.graphics.getFont()
            love.graphics.setFont(self.font)
            love.graphics.print( player.scoreMultiplier.mult .. "X", 10, 10 )
            love.graphics.setFont(font)
        end)
        
        self.x = x
        self.y = y
end

local AlphaMultiplierDisplay = {}
AlphaMultiplierDisplay.__index = AlphaMultiplierDisplay

function AlphaMultiplierDisplay.create()
    local self = {}
    setmetatable(self, AlphaMultiplierDisplay)

    self.font = love.graphics.newFont(48)
    self.x = 0
    self.y = 0

    return self
end

function AlphaMultiplierDisplay:draw()
    if player.scoreMultiplier.mult > 1 then
        local alpha = 255 * (player.scoreMultiplier.duration/2)
        local font = love.graphics.getFont()

        love.graphics.setFont(self.font)
        love.graphics.setColor( 0, 255, 255, alpha )

        love.graphics.print( player.scoreMultiplier.mult .. "X", self.x, self.y )

        love.graphics.setColor( 255, 255, 255 )
        love.graphics.setFont(font)
    end
end

function AlphaMultiplierDisplay:set(x,y)
    self.x = x
    self.y = y
end

local ScoreIndicator = {}
ScoreIndicator.__index = ScoreIndicator

function ScoreIndicator.create()
    local self = {}
    setmetatable(self,ScoreIndicator)
    
    self.scores = {}

    local status, result = pcall(FBMultiplierDisplay.create)

    if status then
        self.multiplier = result
    else
        self.multiplier = AlphaMultiplierDisplay.create()
    end
	
    self.lightning = {
	    color = {255,255,255},
	    duration = 0,
    	maxDuration = 1
	}
	
	self.messages = {}

    return self
end

function ScoreIndicator:reset()
    self.scores = {}
    self.messages = {}
	self.lightning = {
		color = {255,255,255},
		duration = 0,
		maxDuration = 1
	}
end

function ScoreIndicator:add(score, x, y)
    table.insert(self.scores,
        {score = score,
        x = x,
        y = y,
        life = 1})
end

function ScoreIndicator:setMultiplier(x, y)
    if player.scoreMultiplier.mult > 1 then
   
        self.multiplier:set(x,y)
    
    end
end

function ScoreIndicator:displayMessage(text, x, y, duration, color, size)
    local newMessage = {}
    
    newMessage.text = text
    
    if size then
        newMessage.font = love.graphics.newFont(size)
    else
        newMessage.font = love.graphics.getFont() --insecure, what IS getFont()?
    end
    
    newMessage.x = x or ((borders.right - borders.left) / 2) -( newMessage.font:getWidth(text)/2)
    newMessage.y = y or borders.itemGet
    newMessage.duration = duration or #text * 0.2
    newMessage.color = color or {255,255,255}
    
    table.insert(self.messages, newMessage)
end

function ScoreIndicator:doLightning()
	self.lightning.duration = self.lightning.maxDuration
end

function ScoreIndicator:update(dt)
    for i,s in ipairs(self.scores) do
        s.x, s.y = util.move( dt, s.x, s.y, 0, -1, 100 )
        s.life = s.life - dt
        
        if s.life < 0 then
            table.remove(self.scores, i)
        end
    end
    
    for i,m in ipairs(self.messages) do
        if m.duration >= 0 then
            m.duration = m.duration - dt
            
            if m.duration < 0 then
                m.fadeOut = 1
           end
        else
            m.fadeOut = m.fadeOut - dt
           
            if m.fadeOut < 0 then
                table.remove(self.messages, i)
            end
            
        end
    end
	
	if self.lightning.duration >= 0 then
		self.lightning.duration = self.lightning.duration - dt
		
		local color = 255 * self.lightning.duration/self.lightning.maxDuration
		
		love.graphics.setBackgroundColor( color, color, color )
		
		if self.lightning.duration < 0 then
			self.lightning.duration = 0
			love.graphics.setBackgroundColor( 0, 0, 0 )
		end
	end
end

function ScoreIndicator:draw()
    for i,s in ipairs(self.scores) do
        local amt = 255 * s.life
        local color = {0,0,0,amt}
        if s.score > 0 then
            color[2] = 255
        else
            color[1] = 255
        end
        love.graphics.setColor( color )
        love.graphics.print( tostring(s.score),s.x,s.y)
        love.graphics.setColor(255,255,255,255)
    end
    
    for i,m in ipairs(self.messages) do
    
        local font = love.graphics.getFont()
        
        love.graphics.setFont(m.font)
    
        if m.fadeOut then
            love.graphics.setColor( m.color[1], m.color[2], m.color[3], 255 * m.fadeOut )
            love.graphics.print( m.text, m.x, m.y )
            love.graphics.setColor(255,255,255,255)            
        else
            love.graphics.setColor( m.color )
            love.graphics.print( m.text, m.x, m.y )
            love.graphics.setColor(255,255,255,255)                 
        end
        
        love.graphics.setFont(font)
    end
    
    if player.scoreMultiplier.mult > 1 then
        self.multiplier:draw()
    end
end

return ScoreIndicator
