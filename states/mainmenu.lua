

local MainMenu = {}
MainMenu.__index = MainMenu

MainMenu.mainMenuItems = {
    {"Start","start"},
    {"Load","load"},
    {"Fullscreen","fullscreen"},
    {"Toggle 640x480","640x480"},
    {"Select mapset", "mapset"},
    {"Exit","exit"}
}

function MainMenu.load()
    MainMenu.titleFont = love.graphics.newFont(24)
    MainMenu.font = love.graphics.newFont(12)
    love.graphics.setFont(MainMenu.font)

    
    --MainMenu.enemyTypes = {"vsmall","small","medium","hard","vhard"}
    
    MainMenu.mainMenu = Menu.create( 200, 180, "Main Menu", false, 100, 100 )
    MainMenu.mainMenu:addAll( MainMenu.mainMenuItems )
    
    local mapsetMenuItems = Menu.makeMenuitemsAssoc( msm.mapsets, function(item,k) return k end, function(item,k) return k end )
    
    MainMenu.mapSetsMenu = Menu.create( 200, 180, "Mapsets", false, 100, 100 )
    MainMenu.mapSetsMenu:addAll( mapsetMenuItems, true )

    MainMenu.currentMenu = MainMenu.mainMenu    
    
    
end

function MainMenu.onActivation()
    MainMenu.mobs = {}
    
	MainMenu.enemyTypes = {"dummy"}
    
    MainMenu.createMobTimer = 2
end

function MainMenu.update(dt)
    for i,m in ipairs(MainMenu.mobs) do
        m:update(dt)
        
        if m.state == Mob.States.DIE then
            table.remove(MainMenu.mobs,i)
        end
    end

    MainMenu.createMobTimer = MainMenu.createMobTimer - dt
    
    if MainMenu.createMobTimer <= 0 then
        MainMenu.createMobTimer = math.random()*2
        
        local newMob = Mob.create( util.takeRandom(MainMenu.enemyTypes), math.random(borders.left, borders.right), -10, 1 )

        table.insert(MainMenu.mobs, newMob)
    end
end

function MainMenu.draw()
    for i,m in ipairs(MainMenu.mobs) do
        m:draw()
    end
    
    local font = love.graphics.getFont()
    
    love.graphics.setFont(MainMenu.font)
    
    MainMenu.currentMenu:draw()
    
    love.graphics.setColor(255,255,255)
    
    love.graphics.setFont(MainMenu.titleFont)
    
    love.graphics.print( "Enemu 3 : Lumenus", 80, 30 )
    love.graphics.print( "Mapset: " .. msm.current, 90, 60 )
    
    love.graphics.setFont(font)
    
    

end

function MainMenu.keypressed(key)
    local result = MainMenu.currentMenu:keypressed(key)
    
    if MainMenu.currentMenu == MainMenu.mainMenu then
    
        if result then
            if result ~= "abort" then
                if result.item.tag == "start" then
                    gamestate:change("InGame")
                elseif result.item.tag == "load" then
                elseif result.item.tag == "fullscreen" then
                    love.graphics.toggleFullscreen()
                elseif result.item.tag == "mapset" then
                    MainMenu.currentMenu = MainMenu.mapSetsMenu
                    MainMenu.currentMenu:moveSelect(0)
                elseif result.item.tag == "exit" then
                    love.event.push("q")
                    return
                elseif result.item.tag == "640x480" then
                	if scaled then
                		scaled = not love.graphics.setMode(800,600)
                	else
                		scaled = love.graphics.setMode(640,480)
                	end
                end
            end
        end
    elseif MainMenu.currentMenu == MainMenu.mapSetsMenu then
        if result then
            if result ~= "abort" then
                msm:setMapset(result.item.tag)
            end
            
            MainMenu.currentMenu = MainMenu.mainMenu
            MainMenu.currentMenu:moveSelect(0)
        end
    end
end


return MainMenu
