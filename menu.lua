
local Menu = {}
Menu.__index = Menu

function Menu.create(x,y,menuItems)
    local self = {}
    setmetatable(self,Menu)
    
    self.x = x
    self.y = y
    self.items = {}
    
    self:addAll(menuItems)
    
    return self
end

function Menu:addAll(items)
    for i,item in ipairs(items) do
        self:add(item.title or item[1], item.tag or item[2])
    end
end

function Menu:add(item,tag)
    table.insert(self.items,{
        item = item,
        tag = tag
        })
end

function Menu.makeMenuitems( items, tagfn )
    local result = {}
    
    for i,item in ipairs(items) do
        table.insert(result, {
            title = tostring(item),
            tag = tagfn(item)
        })
    end
    
    return result
end



return Menu