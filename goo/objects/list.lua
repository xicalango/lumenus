-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

goo.list = class('goo list', goo.object)

function goo.list:initialize( parent )
    super.initialize(self, parent)
    self.items = {}
    
    self.buttons = {}
    
    self.numItems = 0
    self.offset = 0

    
    self.downButton = goo.button:new(self)
    self.downButton:setText("Down");
    self.downButton:setPos( 10, 10 )
    self.downButton:sizeToText()
    self.downButton.onClick = function(self, button)
        if button == "l" then
            --self.parent.offset = self.parent.offset + 1
            self.parent:shiftDown()
        end
    end
    

    self.upButton = goo.button:new(self)
    self.upButton:setPos( 10, 10 )
    self.upButton:setText("Up")
    self.upButton:sizeToText()
    self.upButton.onClick = function(self, button)
        if button == "l" then
            --self.parent.offset = self.parent.offset - 1
            self.parent:shiftUp()
        end
    end
    
    
end

function goo.list:shiftUp()
    if self.offset == 0 then return end
    
    self.offset = self.offset - 1
    
    self:rebuildButtons()
end

function goo.list:shiftDown()
    if #self.items <= self.numItems then return end
    if self.offset + self.numItems >= #self.items then return end
    
    self.offset = self.offset + 1
    
    self:rebuildButtons()
end

function goo.list:clear()
    self.items = {}
    
    self.upButton:setVisible(false)
    self.downButton:setVisible(false)
end

function goo.list:addMenuItem( _label, _tag )
    table.insert( self.items, { label = _label, tag = _tag } )
    
    if #self.items > self.numItems then
        self.upButton:setVisible(true)
        self.downButton:setVisible(true)
    end
end

function goo.list:rebuildButtons()
    for i,button in ipairs(self.buttons) do
        button:destroy()
    end

    local numButtons = math.min(self.numItems, #self.items)

    if self.offset + numButtons > #self.items  then
        self.offset = #self.items - numButtons 
        if self.offset < 0 then self.offset = 0 end
    end

    self.buttons = {}
    for i = 1, numButtons do
        self.buttons[i] = goo.button:new(self)
        self.buttons[i]:setText(self.items[i+self.offset].label)
        self.buttons[i]:setPos( 15, self.upButton.h + 15 + ((i-1)*self.upButton.h) )
        self.buttons[i]:sizeToText()
        self.buttons[i]:setSize( self.w - 30, self.buttons[i].h )
        self.buttons[i].onClick = function(self, button) self.parent:menuSelect(i,button,self) end
    end 
end

function goo.list:menuSelect(i, button, buttonObj)
    if self.select then self:select(self.items[i+self.offset].tag, button, buttonObj.x, buttonObj.y) end
end

function goo.list:setSize(w,h)
    super.setSize(self,w,h)
  
    self.downButton:setPos( 10, self.h - self.downButton.h - 5 )
    self.numItems = math.floor( ((self.h - self.downButton.h - 10) - (self.upButton.h + 15)) / self.upButton.h )
    
    self:rebuildButtons()
end

function goo.list:draw()
    super.draw(self)
    love.graphics.setColor( 0, 0, 0, 255 )
    love.graphics.rectangle( 'line', 0, 0, self.w, self.h )
end

return goo.list