
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
    {"Mount center","center"},
    {"Mount right","right"},
}

Shop.extrasMenuItems = {
    {"Focus"},
    {"Energy"},
    {"Speed"},
    {"Life"},
}

Shop.settings = {
    prices = {
        focus = 5000,
        speed = 2000,
        life = 20000,
        energy = 2
    },
    
    energyFactor = 1.5,
    
    maxEnergy = 20000
}

local weapons = require('defs/weapons.lua')

function Shop.load()
    Shop.font = love.graphics.newFont(12)
    love.graphics.setFont(Shop.font)


    Shop.mainMenu = Menu.create( 200, 180, "Shop Menu", false, 100, 100 )
    Shop.mainMenu:addAll( Shop.mainMenuItems )
    
    local weaponMenuItems = Menu.makeMenuitemsAssoc( 
        weapons, 
        function(weapon,key) return key end, 
        function(weapon) 
            return weapon.name 
        end )
    
    Shop.weaponMenu = Menu.create( 200, 180, "Weapons", false, 100, 100 )
    Shop.weaponMenu.onSelect = Shop.weaponSelect
    Shop.weaponMenu:addAll( weaponMenuItems, true )
    
    Shop.weaponSlotMenu = Menu.create( 200,180, "Slots", false, 100, 100 )
    Shop.weaponSlotMenu:addAll( Shop.weaponSlotItems )
    
    Shop.extrasMenu = Menu.create( 200, 180, "Extras", false, 100, 100 )
    Shop.extrasMenu.onSelect = Shop.extraSelect
    Shop.extrasMenu:addAll( Shop.extrasMenuItems )
    
    Shop.selectedWeapon = nil
end

function Shop.weaponSelect(item)
    Shop.selectedWeapon = item.tag
end

function Shop.extraSelect(item)
    Shop.selectedExtra = item.title
end

function Shop.onActivation()
    Shop.currentMenu = Shop.mainMenu
    
end

function Shop.draw()
    Shop.currentMenu:draw()
   
    Shop.drawGui()
end

function Shop.printPrice( price, x, y )
    if player.score < price then
        love.graphics.setColor(255,0,0)
    else
        love.graphics.setColor(0,255,0)
    end
    
    love.graphics.print( "Price: " .. price, x, y)
    
    love.graphics.setColor(255,255,255)
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
        local weapon = weapons[Shop.selectedWeapon]
        love.graphics.print( "Name: " .. weapon.name, 50, 300)
        
        Shop.printPrice( weapon.price, 50, 320 )
        
        love.graphics.print( "Description: " , 50, 340)
        love.graphics.printf( weapon.desc or "No description available...", 50, 360, 750)
    
    elseif Shop.currentMenu == Shop.extrasMenu and Shop.selectedExtra then
        if Shop.selectedExtra == "Focus" then
            love.graphics.print( "Level: " .. player.extras.focus.level .. "/" .. player.extras.focus.maxLevel, 50, 300 )
            
            if player.extras.focus.level < player.extras.focus.maxLevel then
                Shop.printPrice( (player.extras.focus.level+1)*Shop.settings.prices.focus, 50, 320 )
            end
            
            love.graphics.print( "Description: " , 50, 340)
            love.graphics.printf( "No description available...", 50, 360, 750)
        elseif Shop.selectedExtra == "Speed" then
            love.graphics.print( "Level: " .. player.extras.speed.level .. "/" .. player.extras.speed.maxLevel, 50, 300 )
            
            if player.extras.speed.level < player.extras.speed.maxLevel then
                Shop.printPrice( (player.extras.speed.level+1)*Shop.settings.prices.speed, 50, 320 )
            end
            
            love.graphics.print( "Description: " , 50, 340)
            love.graphics.printf( "No description available...", 50, 360, 750)
        elseif Shop.selectedExtra == "Energy" then
            love.graphics.print( "Current max Energy: " .. math.floor(player.maxEnergy), 50, 300)    
            love.graphics.print( "Current Energy regain: " .. math.floor(player.energyRegain) .. "/second", 50, 320) 
            
            if player.maxEnergy < Shop.settings.maxEnergy then
            
                love.graphics.print( "Next level max Energy: " .. math.floor(player.maxEnergy * Shop.settings.energyFactor), 50, 340) 
                love.graphics.print( "Next level Energy regain: " .. math.floor(player.energyRegain * Shop.settings.energyFactor) .. "/second", 50, 360) 
                
                Shop.printPrice( math.floor(player.maxEnergy * Shop.settings.energyFactor)*Shop.settings.prices.energy, 50, 380 )
            end
        elseif Shop.selectedExtra == "Life" then
            Shop.printPrice( Shop.settings.prices.life, 50, 300 )
        end
    
    end
    
    
end

function Shop.keypressed(key)
    local result = Shop.currentMenu:keypressed(key)
    
    Shop.message = nil
    
    if result then
        if result == "abort" then
            if Shop.currentMenu == Shop.weaponSlotMenu then
                Shop.currentMenu = Shop.weaponMenu
            elseif Shop.currentMenu ~= Shop.mainMenu then
                Shop.currentMenu = Shop.mainMenu
            else
                gamestate:change("InGame")
            end
        else
            
            if Shop.currentMenu == Shop.mainMenu then
            
            
                if result.item.title == "Weapons" then
                    Shop.currentMenu = Shop.weaponMenu
                    Shop.currentMenu:moveSelect(0)
                elseif result.item.title == "Extras" then
                    Shop.currentMenu = Shop.extrasMenu
                    Shop.currentMenu:moveSelect(0)                    
                elseif result.item.title == "Exit" then
                    gamestate:change("InGame")
                end
                
            elseif Shop.currentMenu == Shop.weaponMenu then
                local weapon = weapons[result.item.tag]
                Shop.selectedWeapon = result.item.tag
                
                if Shop.priceCheck(weapon.price, weapon.name) then
                    Shop.currentMenu = Shop.weaponSlotMenu
                end
            
            elseif Shop.currentMenu == Shop.weaponSlotMenu then
            
                if player.ship.weapons[result.item.tag].weapon and player.ship.weapons[result.item.tag].weapon.id == Shop.selectedWeapon then
                    Shop.message = { color = {255,0,0}, msg = "Weapon already mounted!" }
                else
            
                    player:changeScore(-weapons[Shop.selectedWeapon].price)
                    
                    player.ship:mountWeapon( result.item.tag, Shop.selectedWeapon )
                    
                    Shop.selectedWeapon = nil
                    Shop.currentMenu = Shop.weaponMenu
                    Shop.currentMenu:moveSelect(0)

                end
            
            elseif Shop.currentMenu == Shop.extrasMenu then
                if result.item.title == "Focus" then
                    if Shop.priceCheck((player.extras.focus.level+1)*Shop.settings.prices.focus, "Focus") then
                        if player.extras.focus.level == player.extras.focus.maxLevel then
                            Shop.message = { color = {255,0,0}, msg = "Focus already on max level!" }
                        else
                            player:changeScore(-Shop.settings.prices.focus)
                            player.extras.focus.level = player.extras.focus.level + 1
                        end
                    end
                elseif result.item.title == "Speed" then
                    if Shop.priceCheck((player.extras.speed.level+1)*Shop.settings.prices.speed, "Speed") then
                        if player.extras.speed.level == player.extras.speed.maxLevel then
                            Shop.message = { color = {255,0,0}, msg = "Speed already on max level!" }
                        else
                            player:changeScore(-Shop.settings.prices.speed)
                            player.extras.speed.level = player.extras.speed.level + 1
                            player.ship.speed = 200 + (player.extras.speed.level-1)*25
                        end
                    end
                elseif result.item.title == "Energy" then
                    if Shop.priceCheck(math.floor(player.maxEnergy * Shop.settings.energyFactor)*Shop.settings.prices.energy, "Energy") then
                        if player.maxEnergy == Shop.settings.maxEnergy then
                            Shop.message = { color = {255,0,0}, msg = "Max Energy reached!" }
                        else
                            player:changeScore(-math.floor(player.maxEnergy * Shop.settings.energyFactor)*Shop.settings.prices.energy)
                            player.maxEnergy = math.floor(player.maxEnergy*Shop.settings.energyFactor)
                            player.energyRegain = math.floor(player.energyRegain * Shop.settings.energyFactor)
                            
                            if player.maxEnergy > Shop.settings.maxEnergy then
                                player.maxEnergy = Shop.settings.maxEnergy
                            end
                        end
                    end
                elseif result.item.title == "Life" then
                    if Shop.priceCheck(Shop.settings.prices.life, "Life") then
                        player:changeScore(-Shop.settings.prices.life)
                        player.lives = player.lives + 1
                    end
                end
                
                Shop.selectedExtra = nil
                Shop.currentMenu = Shop.extrasMenu
                Shop.currentMenu:moveSelect(0)
            
            end
        end
    end
end

function Shop.priceCheck(price, object)
    if player.score >= price then
        return true
    else
        Shop.message = { color = {255,0,0}, msg = "Not enough money to buy " .. object .."!" }
        return false
    end
end


return Shop