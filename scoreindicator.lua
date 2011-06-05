
local ScoreIndicator = {}
ScoreIndicator.__index = ScoreIndicator

function ScoreIndicator.create()
    local self = {}
    setmetatable(self,ScoreIndicator)
    
    self.scores = {}
    
    self.multiplier = {
        font = love.graphics.newFont(48),
        framebuffer = love.graphics.newFramebuffer( 100, 50 ),
        lifetime = 0,
        x = 0,
        y = 0
    }
    
    return self
end

function ScoreIndicator:reset()
    self.scores = {}
    
    self.multiplier = {
        font = love.graphics.newFont(48),
        framebuffer = love.graphics.newFramebuffer( 100, 50 ),
        lifetime = 0,
        x = 0,
        y = 0
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
    
        self.multiplier.framebuffer:renderTo(function()
            local font = love.graphics.getFont()
            love.graphics.setFont(self.multiplier.font)
            love.graphics.print( player.scoreMultiplier.mult .. "X", 0, 0 )
            love.graphics.setFont(font)
        end)
        
        self.multiplier.x = x
        self.multiplier.y = y
    
    end
end

function ScoreIndicator:update(dt)
    for i,s in ipairs(self.scores) do
        s.x, s.y = util.move( dt, s.x, s.y, 0, -1, 100 )
        s.life = s.life - dt
        
        if s.life < 0 then
            table.remove(self.scores,i)
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
    
    if player.scoreMultiplier.mult > 1 then
        love.graphics.setColor( 0,255,255 )    
        love.graphics.draw(self.multiplier.framebuffer, self.multiplier.x, self.multiplier.y, 0,        player.scoreMultiplier.duration/2, nil, 50, 25)
        love.graphics.setColor( 255, 255, 255 )
    end
end

return ScoreIndicator