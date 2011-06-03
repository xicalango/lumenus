-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local Menu = {}
Menu.__index = Menu

Menu.spaces = {
    padding = 2,
    marginbottom = 3
}

function Menu.create(w, h, label, submenu, x, y )
    local self = {}
    setmetatable(self,Menu)
    
    self.w = w
    self.h = h

    self.x = x or 0
    self.y = y or 0

    self.items = {}
    
    self.selectedItem = 1
    self.scroll = 0
    
    self.submenu = submenu
    
    self.label = label or ""
    
    self.heightStep = 
        love.graphics.getFont():getHeight()+
        2*Menu.spaces.padding+
        Menu.spaces.marginbottom
    
    self.maxItems = math.floor( h / self.heightStep )
    
    return self
end

function Menu:addItem( title, tag )
    table.insert(self.items, {
        title = title,
        tag = tag
        })
end

function Menu:addAll( items )
    for i,v in ipairs(items) do
        self:addItem( v.title or v[1], v.tag or v[2] )
    end
end

function Menu.makeMenuitems( items, tagfn, titlefn )
    local result = {}
    titlefn = titlefn or tostring
    
    for i,item in ipairs(items) do
        table.insert(result, {
            title = titlefn(item),
            tag = tagfn(item)
        })
    end
    
    return result
end

function Menu.makeMenuitemsAssoc( items, tagfn, titlefn )
    local result = {}
    titlefn = titlefn or tostring
    
    for k,item in pairs(items) do
        table.insert(result, {
            title = titlefn(item),
            tag = tagfn(item)
        })
    end
    
    return result
end

function Menu:rebuild( items, tagfn )
    self.items = {}

    if tagfn ~= nil then
        items = Menu.makeMenuitems( items, tagfn ) 
    end
    
    self:addAll( items )
end

function Menu:draw()
    local font = love.graphics.getFont()

    love.graphics.push()
    love.graphics.translate( self.x, self.y )
    
    if self.submenu then
        love.graphics.setColor( {32,32,32} )
    else
        love.graphics.setColor( {0,0,0} )
    end
    
    love.graphics.rectangle( "fill", 0, 0, self.w, self.h )
    
    for i = 1, math.min(self.maxItems,#self.items) do
        local iMenuitem = i + self.scroll

        if iMenuitem then
            
            if iMenuitem == self.selectedItem then
                local fillmode = "line"
                
                if self.focus then
                    fillmode = "fill"
                end
            
                love.graphics.setColor( {0,0,255} )
                love.graphics.rectangle( fillmode, 
                    Menu.spaces.padding, 
                    Menu.spaces.padding + (i-1)*self.heightStep, 
                    self.w-Menu.spaces.padding*2, 
                    (font:getHeight()+2*Menu.spaces.padding)   )
            end
            
            love.graphics.setColor( {255,255,255} )
            
            love.graphics.print( self.items[iMenuitem].title or "", Menu.spaces.padding*2, 2*Menu.spaces.padding + (i-1)*self.heightStep )
                    
        end
        
    end
    
    love.graphics.pop()
end

function Menu:keypressed(key)
    if util.keycheck(key,keyConfig.up) then
        self:moveSelect(-1)
    elseif util.keycheck(key,keyConfig.down) then
        self:moveSelect(1)
    elseif util.keycheck(key,keyConfig.select) then
        return { 
            item = self.items[self.selectedItem], 
            xpos = Menu.spaces.padding,
            ypos = (self.selectedItem-self.scroll-1)*self.heightStep
            }
    elseif util.keycheck(key,keyConfig.abort) then
        return "abort"
    end
    
    return nil
end

function Menu:moveSelect(d)
    self.selectedItem = self.selectedItem + d
    
    if self.selectedItem > self.scroll + self.maxItems then
        self.scroll = self.scroll + 1
    elseif self.selectedItem < self.scroll + 1 then
        self.scroll = self.scroll - 1
    end
    
    if self.selectedItem < 1 then
        self.selectedItem = #self.items
        if #self.items <= self.maxItems then
            self.scroll = 0
        else
            self.scroll = #self.items - self.maxItems
        end
    elseif self.selectedItem > #self.items then
        self.selectedItem = 1
        self.scroll = 0
    end
    
    if self.onSelect then
        self.onSelect(self.items[self.selectedItem])
    end
end

return Menu