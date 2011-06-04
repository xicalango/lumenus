
local ScoreIndicator = {}
ScoreIndicator.__index = ScoreIndicator

function ScoreIndicator.create()
    local self = {}
    setmetatable(self,ScoreIndicator)
    
    self.scores = {}
    
    return self
end

function ScoreIndicator:add(score, x, y)
    table.insert(self.scores,
        {score = score,
        x = x,
        y = y,
        life = 1})
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
end

return ScoreIndicator