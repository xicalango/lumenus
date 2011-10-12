-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local Path = {}
Path.__index = Path

function Path.create( pathNodes, isRepeating )
    local self = {}
    setmetatable(self,Path)
    
    self.pathNodes = pathNodes
    self.currentNode = 1
    
    self.repeating = isRepeating
    
    return self
end

function Path:getCurrentNode()
    return self.pathNodes[self.currentNode]
end

function Path:getCurrentCoor()
    local currentNode = self:getCurrentNode()
    
    if currentNode == nil then
        return nil
    end
    
    return currentNode[1], currentNode[2]
end

function Path:getDir(x, y)
	local node = self:getCurrentNode()
	
	if node == nil then
		return nil
	end
	
	return util.sign(node[1]-x), util.sign(node[2]-y)
end

function Path:nextNode()
    self.currentNode = self.currentNode + 1
    
    if self.currentNode == #self.pathNodes + 1 then
        if self.repeating then
            self.currentNode = 1
        else
            self.currentNode = 0
        end
    end
    
    return self:getCurrentNode()
end

function Path:reachedNode(x, y, d)
    d = d or 10
    local currentNode = self:getCurrentNode()
    
    if currentNode == nil then
        return false
    end
    
    local dx = currentNode[1] - x
    local dy = currentNode[2] - y
    
    local dq = dx*dx + dy*dy
    
    return dq <= d*d
end

function Path:getFlyFn()

	local flyFn = function( dt, x, y, dx, dy, speedx, speedy )
		dx, dy = self:getDir(x,y)
		
		return x + dx * speedx * dt, y + dy * (speedy or speedx) * dt
	end

	return flyFn
end

return Path