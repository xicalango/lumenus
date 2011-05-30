-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local GameState = {}
GameState.__index = GameState

function GameState.create(statedefs)
    local self = {}
    setmetatable(self,GameState)
    
    self.states = {}
    self.currentState = {}
    self.currentStateName = ""
    setmetatable(self.currentState, {__index = function() return nil; end})
    
    if statedefs ~= nil then
        self:registerAll(statedefs)
    end
    
    return self
end

function GameState:registerAll( statedefs )
    for name,statedef in pairs(statedefs) do
        self:register( name, statedef )
    end
end

function GameState:register( name, statedef )
    self.states[name] = statedef
    
    if statedef.load then statedef.load() end
end

--[[
-- Changes the state to the state given by name
-- Calls onStateChange with the old state. When this method returns false, the state is not changed.
--]]
function GameState:change( name )
    self.oldstate = self.currentStateName

    if self.states[name].onStateChange then
        if self.states[name].onStateChange(self.oldstate) then
            if self.currentState.onDeactivation then self.currentState.onDeactivation() end
        
            self.currentState = self.states[name]
            self.currentStateName = name
        
            if self.currentState.onActivation then self.currentState.onActivation() end
        end
    else
        if self.currentState.onDeactivation then self.currentState.onDeactivation() end
        
        self.currentState = self.states[name]
        self.currentStateName = name
        
        if self.currentState.onActivation then self.currentState.onActivation() end
    end
    
end

function GameState:foreignCall( statename, callfn, ... )
    pcall(self.states[statename][callfn], ...)
end

function GameState:update(dt)
    if self.currentState.update then self.currentState.update(dt) end
end

function GameState:draw()
    if self.currentState.draw then self.currentState.draw() end
end

function GameState:keypressed(key)
    if self.currentState.keypressed then self.currentState.keypressed(key) end
end

function GameState:keyreleased(key)
    if self.currentState.keyreleased then self.currentState.keyreleased(key) end
end

function GameState:mousepressed(x, y, button)
    if self.currentState.mousepressed then self.currentState.mousepressed(x,y,button) end
end

function GameState:mousereleased(x, y, button)
    if self.currentState.mousereleased then self.currentState.mousereleased(x,y,button) end
end

return GameState