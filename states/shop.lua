-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local Shop = {}
Shop.__index = Shop

Shop.mainMenuItems = {
    {"Weapons", "weapons"},
    {"Upgrade Weapons", "upgrade"},
    {"Extras", "extras"},
    {"Save", "save"},
    {"Exit", "exit"}
}

Shop.weaponSlotItems = {
    {"Mount left","left"},
    {"Mount center","center"},
    {"Mount right","right"},
}

Shop.extrasMenuItems = {
    {"Focus", "focus"},
    {"Energy", "energy"},
    {"Speed", "speed"},
	{"Shield", "shield"},
	{"Ship clone", "clone"},
    {"Life", "life"},
}

Shop.settings = {
    prices = {
        focus = 5000,
        speed = 2000,
        life = 20000,
        energy = 2,
		shield = 10000,
		clone = 1000000
    },
    
    energyFactor = 1.5,
    
    maxEnergy = 20000,
	
	maxShotHits = 2
}

local weapons = require('defs/weapons.lua')

function Shop.load()
    Shop.font = love.graphics.newFont(12)
    love.graphics.setFont(Shop.font)


    Shop.mainMenu = Menu.create( 200, 180, "Shop Menu", false, 100, 100 )
    Shop.mainMenu:addAll( Shop.mainMenuItems )
    
    local weaponMenuItems = Menu.makeMenuitemsAssoc( 
        util.filter(weapons, 
            function(w) 
                return not w.notInShop
            end
        ), 
        function(weapon,key) return key end, 
        function(weapon) 
            return weapon.name 
        end 
    )
    
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

function Shop.upgradeSelect(item)
    Shop.selectedUpgrade = item.tag
end

function Shop.weaponSelect(item)
    Shop.selectedWeapon = item.tag
end

function Shop.extraSelect(item)
    Shop.selectedExtra = item.tag
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

function Shop.drawWeaponInfo()
    local weapon = weapons[Shop.selectedWeapon]
    love.graphics.print( "Name: " .. weapon.name, 50, 300)
    
    Shop.printPrice( weapon.price, 50, 320 )
    
    love.graphics.print( "Description: " , 50, 340)
    love.graphics.printf( weapon.desc or "No description available...", 50, 360, 750)
end

function Shop.drawExtraInfo()
    if Shop.selectedExtra == "focus" then
        love.graphics.print( "Level: " .. player.extras.focus.level .. "/" .. player.extras.focus.maxLevel, 50, 300 )
        
        if player.extras.focus.level < player.extras.focus.maxLevel then
            Shop.printPrice( (player.extras.focus.level+1)*Shop.settings.prices.focus, 50, 320 )
        end
        
        love.graphics.print( "Description: " , 50, 340)
        love.graphics.printf( "No description available...", 50, 360, 750)
    elseif Shop.selectedExtra == "speed" then
        love.graphics.print( "Level: " .. player.extras.speed.level .. "/" .. player.extras.speed.maxLevel, 50, 300 )
        
        if player.extras.speed.level < player.extras.speed.maxLevel then
            Shop.printPrice( (player.extras.speed.level+1)*Shop.settings.prices.speed, 50, 320 )
        end
        
        love.graphics.print( "Description: " , 50, 340)
        love.graphics.printf( "No description available...", 50, 360, 750)
    elseif Shop.selectedExtra == "energy" then
        love.graphics.print( "Current max Energy: " .. math.floor(player.maxEnergy), 50, 300)    
        love.graphics.print( "Current Energy regain: " .. math.floor(player.energyRegain) .. "/second", 50, 320) 
        
        if player.maxEnergy < Shop.settings.maxEnergy then
        
            love.graphics.print( "Next level max Energy: " .. math.floor(player.maxEnergy * Shop.settings.energyFactor), 50, 340) 
            love.graphics.print( "Next level Energy regain: " .. math.floor(player.energyRegain * Shop.settings.energyFactor) .. "/second", 50, 360) 
            
            Shop.printPrice( math.floor(player.maxEnergy * Shop.settings.energyFactor)*Shop.settings.prices.energy, 50, 380 )
        end
    elseif Shop.selectedExtra == "life" then
        Shop.printPrice( math.floor(player.score/4) + Shop.settings.prices.life, 50, 300 )
	elseif Shop.selectedExtra == "shield" then
		love.graphics.print( "Current shield level: " .. player.maxShotHits, 50, 300)    

        if player.maxShotHits < Shop.settings.maxShotHits then
            love.graphics.print( "Next level: " .. player.maxShotHits+1, 50, 320)  
            
            Shop.printPrice( (player.maxShotHits+1)*Shop.settings.prices.shield, 50, 380 )
        end
	elseif Shop.selectedExtra == "clone" then
		love.graphics.print( "Nee, heute nicht" , 50, 300)    
    end
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
        Shop.drawWeaponInfo()
    elseif Shop.currentMenu == Shop.extrasMenu and Shop.selectedExtra then
        Shop.drawExtraInfo()
    elseif Shop.currentMenu == Shop.upgradeMenu and Shop.selectedUpgrade then
        Shop.drawUpgradeInfo()
    end
end

function Shop.drawUpgradeInfo()
    local weapon = player.ship.weapons[Shop.selectedUpgrade].weapon
    local weaponDef = weapons[weapon.id]
    
    if weaponDef.upgrade then
        local upgradeDef = weapons[weaponDef.upgrade]
        love.graphics.print( "Upgrade to: " .. upgradeDef.name, 50, 300)
    
        Shop.printPrice( upgradeDef.price, 50, 320 )
        
        love.graphics.print( "Description: " , 50, 340)
        love.graphics.printf( upgradeDef.desc or "No description available...", 50, 360, 750)
    else
        love.graphics.print( "No upgrades available", 50, 300)
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
            
            
                if result.item.tag == "weapons" then
                    Shop.currentMenu = Shop.weaponMenu
                    Shop.currentMenu:moveSelect(0)
                elseif result.item.tag == "upgrade" then
                    Shop.upgradeMenu = Shop.createUpgradeMenu()
                    Shop.currentMenu = Shop.upgradeMenu
                    Shop.currentMenu:moveSelect(0)
                elseif result.item.tag == "extras" then
                    Shop.currentMenu = Shop.extrasMenu
                    Shop.currentMenu:moveSelect(0)                    
                elseif result.item.tag == "exit" then
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
            elseif Shop.currentMenu == Shop.upgradeMenu then
                    local weapon = player.ship.weapons[result.item.tag].weapon
                    local weaponDef = weapons[weapon.id]
                    
                    if weaponDef.upgrade then
                        local upgradeDef = weapons[weaponDef.upgrade]
                        if Shop.priceCheck(upgradeDef.price, upgradeDef.name) then
                            player:changeScore(-upgradeDef.price)
                            
                            player.ship:mountWeapon( result.item.tag, weaponDef.upgrade )
                            
                            Shop.upgradeMenu = Shop.createUpgradeMenu()
                            Shop.currentMenu = Shop.upgradeMenu
                            Shop.currentMenu:moveSelect(0)
                        end
                    else
                        Shop.message = { color = {255,0,0}, msg = "No upgrade available!" }
                    end
                    
                    

            elseif Shop.currentMenu == Shop.extrasMenu then
                if result.item.tag == "focus" then
                    if Shop.priceCheck((player.extras.focus.level+1)*Shop.settings.prices.focus, "Focus") then
                        if player.extras.focus.level == player.extras.focus.maxLevel then
                            Shop.message = { color = {255,0,0}, msg = "Focus already on max level!" }
                        else
                            player:changeScore(-Shop.settings.prices.focus)
                            player.extras.focus.level = player.extras.focus.level + 1
                        end
                    end
                elseif result.item.tag == "speed" then
                    if Shop.priceCheck((player.extras.speed.level+1)*Shop.settings.prices.speed, "Speed") then
                        if player.extras.speed.level == player.extras.speed.maxLevel then
                            Shop.message = { color = {255,0,0}, msg = "Speed already on max level!" }
                        else
                            player:changeScore(-Shop.settings.prices.speed)
                            player.extras.speed.level = player.extras.speed.level + 1
                            player.ship.speed = 200 + (player.extras.speed.level-1)*25
                        end
                    end
                elseif result.item.tag == "energy" then
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
                elseif result.item.tag == "life" then
                    if Shop.priceCheck(math.floor(player.score/4) + Shop.settings.prices.life, "Life") then
                        player:changeScore(-(math.floor(player.score/4) + Shop.settings.prices.life))
                        player.lives = player.lives + 1
                    end
					
				elseif result.item.tag == "shield" then
					if Shop.priceCheck((player.maxShotHits+1)*Shop.settings.prices.shield, "Shield") then
						if player.maxShotHits == Shop.settings.maxShotHits then
							Shop.message = { color = {255,0,0}, msg = "Max Shield reached!" }
						else
							player:changeScore(-(player.maxShotHits+1)*Shop.settings.prices.shield)
                            player.maxShotHits = player.maxShotHits+1
						end
					end
					
                end
                
                Shop.selectedExtra = nil
                Shop.currentMenu = Shop.extrasMenu
                Shop.currentMenu:moveSelect(0)
            
            end
        end
    end
end

function Shop.createUpgradeMenu()
    local menuItems = {}
    
    for k,v in pairs(player.ship.weapons) do
        if v.weapon then
            table.insert(menuItems, 
                {util.capitalize(k) .. " Weapon: " .. tostring(v.weapon),k}
                )
        end
    end
    
    local menu = Menu.create( 200, 180, "Upgrade", false, 100, 100 )
    menu.onSelect = Shop.upgradeSelect
    menu:addAll( menuItems, true )
    
    return menu
end

function Shop.updateUpgradeMenu()
    local menuItems = {}
    
    for k,v in pairs(player.ship.weapons) do
        if v.weapon then
            table.insert(menuItems, 
                {util.capitalize(k) .. " Weapon: " .. tostring(v.weapon),k}
                )
        end
    end
    
    Shop.upgradeMenu:rebuild(menuItems)
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
