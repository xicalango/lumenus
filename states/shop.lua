
local Shop = {}
Shop.__index = Shop

Shop.mainMenuItems = {
    {"Weapons"},
    {"Extras"},
    {"Save"},
    {"Exit"}
}

Shop.weaponSlotItems = {
    {"Mount left","left"},
    {"Mount right","right"},
    {"Mount center","center"}
}

local weapons = require('defs/weapons.lua')

function Shop.load()
    Shop.font = love.graphics.newFont(12)
    love.graphics.setFont(Shop.font)


    Shop.mainMenu = Menu.create( 200, 180, "Shop Menu", false, 100, 100 )
    Shop.mainMenu:addAll( Shop.mainMenuItems )
    
    local weaponMenuItems = Menu.makeMenuitemsAssoc( 
        weapons, 
        function(weapon) return weapon end, 
        function(weapon) 
            return weapon.name 
        end )
    
    Shop.weaponMenu = Menu.create( 200, 180, "Weapons", false, 100, 100 )
    Shop.weaponMenu.onSelect = Shop.weaponSelect
    Shop.weaponMenu:addAll( weaponMenuItems )
    
    Shop.weaponSlotMenu = Menu.create( 200,180, "Slots", false, 100, 100 )
    Shop.weaponSlotMenu:addAll( Shop.weaponSlotItems )
    
    Shop.selectedWeapon = nil
end

function Shop.weaponSelect(item)
    Shop.selectedWeapon = item.tag
end

function Shop.onActivation()
    Shop.currentMenu = Shop.mainMenu
    
end

function Shop.update(dt)
    --Shop.mainMenu:update(dt)
end

function Shop.draw()
    Shop.currentMenu:draw()
   
    Shop.drawGui()
end

function Shop.drawGui()
    love.graphics.print( "Score/Money: " .. player.score, 50, 25)
    love.graphics.print( "Lives: " .. player.lives, 50, 45)
    
    if Shop.message then
        love.graphics.setColor( Shop.message.color or {255,255,255} )
        love.graphics.printf(Shop.message.msg, 50, 65, 300)
        love.graphics.setColor( 255,255,255 )
    end
    
    love.graphics.print( "Left Weapon: " .. tostring(player.ship.weapons.left.weapon or ""), 400, 25 )
    love.graphics.print( "Center Weapon: " .. tostring(player.ship.weapons.center.weapon or ""), 400, 45 )
    love.graphics.print( "Right Weapon: " .. tostring(player.ship.weapons.right.weapon or ""), 400, 65 )
    
    if Shop.currentMenu == Shop.weaponMenu and Shop.selectedWeapon then
        local weapon = Shop.selectedWeapon
        love.graphics.print( "Name: " .. weapon.name, 50, 300)
        
        if player.score < weapon.price then
            love.graphics.setColor(255,0,0)
        else
            love.graphics.setColor(0,255,0)
        end
        
        love.graphics.print( "Price: " .. weapon.price, 50, 320)
        
        love.graphics.setColor(255,255,255)
        
        love.graphics.print( "Description: " , 50, 340)
        love.graphics.printf( weapon.desc or "No description available...", 50, 360, 750)
    end
end

function Shop.keypressed(key)
    local result = Shop.currentMenu:keypressed(key)
    
    Shop.message = nil
    
    if result then
        if result == "abort" then
            if Shop.currentMenu ~= Shop.mainMenu then
                Shop.currentMenu = Shop.mainMenu
            else
                gamestate:change("InGame")
            end
        else
            
            if Shop.currentMenu == Shop.mainMenu then
            
            
                if result.item.title == "Weapons" then
                    Shop.currentMenu = Shop.weaponMenu
                    Shop.currentMenu:moveSelect(0)
                elseif result.item.title == "Exit" then
                    gamestate:change("InGame")
                end
                
            elseif Shop.currentMenu == Shop.weaponMenu then
                local weapon = result.item.tag
                Shop.selectedWeapon = weapon
                if player.score >= weapon.price then
                    Shop.currentMenu = Shop.weaponSlotMenu
                else
                    Shop.message = { color = {255,0,0}, msg = "Not enough money to buy " .. weapon.name .."!" }
                end
            
            elseif Shop.currentMenu == Shop.weaponSlotMenu then
            
                player:changeScore(-Shop.selectedWeapon.price)
                
                player.ship:mountWeapon( result.item.tag, Shop.selectedWeapon.id )
                
                Shop.selectedWeapon = nil
                Shop.currentMenu = Shop.weaponMenu
                Shop.currentMenu:moveSelect(0)
            
            end
        end
    end
end

function Shop.keyreleased(key)
    --Shop.mainMenu:keyreleased(key)
end

function Shop.mousepressed(x,y,button)
    print(x,y)
end

return Shop