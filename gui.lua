-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local Gui = {}
Gui.__index = Gui

function Gui.create(x,y)
    local self = {}
    setmetatable(self,Gui)
    
    self.x = x
    self.y = y

    self.showScore = 0
    
    self.font = love.graphics.newFont(20)
	
	self.elements = {}
	
	self.mapElements = {}
    
	self:init()
	
    return self
end

function Gui:insertElement( outputType, label, contentFn )
	outputFn = Gui.printTextValue
	if outputType == "text" then
		outputFn = Gui.printTextValue
	elseif outputType == "textmv" then
		outputFn = Gui.printTextMaxValValue
	elseif outputType == "bar" then
		outputFn = Gui.printBarValue
	end

	table.insert(self.elements, {
		output = outputFn,
		label = label,
		fn = contentFn
		})
	return #self.elements
end

function Gui:removeElement( n )
	table.remove(self.elements, n)
end

function Gui:insertMapElement( outputType, label, contentFn )
	outputFn = Gui.printTextValue
	if outputType == "text" then
		outputFn = Gui.printTextValue
	elseif outputType == "textmv" then
		outputFn = Gui.printTextMaxValValue
	elseif outputType == "bar" then
		outputFn = Gui.printBarValue
	end

	table.insert(self.mapElements, {
		output = outputFn,
		label = label,
		fn = contentFn
		})
	return #self.mapElements
end

function Gui:removeMapElement( n )
	table.remove(self.mapElements, n)
end

function Gui:clearMapElements()
	self.mapElements = {}
end

function Gui:init()
	self:insertElement( 
		Gui.printTextValue,
		"Level: ",
		function() return level end)

	--todo: do this for all other elements ;)
		
	table.insert(self.elements, {
		output = Gui.printTextValue, 
		label = "Score: ",
		fn = function() return math.floor(self.showScore) end 
		})

	table.insert(self.elements, {
		output = Gui.printTextValue, 
		label = "Lives: ",
		fn = function() return player.lives end 
		})

	table.insert(self.elements, {
		output = Gui.printBarValue, 
		label = "Energy: ",
		fn = function() return player.energy, player.maxEnergy end 
		})
		
	table.insert(self.elements, {
		output = Gui.printTextValue, 
		label = "Framecounter: ",
		fn = function() return currentmap.timeline.framecounter end 
		})
		
	table.insert(self.elements, {
		output = Gui.printTextValue, 
		label = "Left Weapon: ",
		fn = function() return tostring(player.ship.weapons.left.weapon or "") end 
		})
		
	table.insert(self.elements, {
		output = Gui.printTextValue, 
		label = "Center Weapon: ",
		fn = function() return tostring(player.ship.weapons.center.weapon or "") end 
		})
		
	table.insert(self.elements, {
		output = Gui.printTextValue, 
		label = "Right Weapon: ",
		fn = function() return tostring(player.ship.weapons.right.weapon or "") end 
		})
end

function Gui.print(linecounter, text, x, y, r, sx, sy )
    local font = love.graphics.getFont()
    love.graphics.print( text, x, y + linecounter * font:getHeight(), r, sx, sy )
    return linecounter + 1
end

function Gui:printTextValue( linecounter, label, fn )
	return Gui.print( linecounter, label .. fn(), 10, 10 )
end

function Gui:printTextMaxValValue( linecounter, label, fn )
	local val,maxVal = fn()
	return Gui.print( linecounter, label .. val .. "/" .. maxVal, 10, 10 )
end

function Gui:printBarValue( linecounter, label, fn )
	local val,maxVal = fn()
	
	linecounter = Gui.print( linecounter, label, 10, 10)
        
    local y = (linecounter * self.font:getHeight())+self.font:getHeight()*2/3
    
    love.graphics.setColor( 255 - (val/maxVal) * 255, (val/maxVal) * 255, 0 )
    love.graphics.rectangle( "fill", 10, y, (val/maxVal) * 200, self.font:getHeight()/2 )
    
    linecounter = Gui.print( linecounter, "", 10, 10)
    
    love.graphics.setColor( 255, 255, 255 )
	
	return linecounter 
end

function Gui:draw()
    love.graphics.push()
    love.graphics.translate(self.x,self.y)
    local _r,_g,_b,_a = love.graphics.getColor()
    local font = love.graphics.getFont()
    
    love.graphics.setFont(self.font)
	
    local linecounter = 0
	
	for i,e in ipairs(self.elements) do
		linecounter = e.output( self, linecounter, e.label, e.fn )
	end
	
	if #self.mapElements > 0 then
	
		linecounter = Gui.print( linecounter, "=== Map ===", 10, 10 )
		
		for i,e in ipairs(self.mapElements) do
			linecounter = e.output( self, linecounter, e.label, e.fn )
		end
	    
	end
	
    love.graphics.setFont(font)
    love.graphics.setColor(_r,_g,_b,_a)
    love.graphics.pop()

end

function Gui:update(dt)
    if self.showScore ~= player.score then
        local ds = player.score - self.showScore
        if ds > 0 then
            self.showScore = self.showScore + (ds/50)+1
            
            if self.showScore > player.score then
                self.showScore = player.score
            end
        else
            self.showScore = player.score
        end
    end

end

return Gui
