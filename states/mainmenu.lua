

local MainMenu = {}
MainMenu.__index = MainMenu

MainMenu.mainMenuItems = {
    {"Start"},
    {"Load"},
    {"Fullscreen"},
    {"Exit"}
}

function MainMenu.load()
    MainMenu.titleFont = love.graphics.newFont(24)
    MainMenu.font = love.graphics.newFont(12)
    love.graphics.setFont(MainMenu.font)

    
    --MainMenu.enemyTypes = {"vsmall","small","medium","hard","vhard"}
    
    
    MainMenu.mainMenu = Menu.create( 200, 180, "Main Menu", false, 100, 100 )
    MainMenu.mainMenu:addAll( MainMenu.mainMenuItems )
end

function MainMenu.onActivation()
    MainMenu.mobs = {}
    
    if currentmap then
        MainMenu.enemyTypes = currentmap.enemyTypes
    else
        MainMenu.enemyTypes = {"vsmall"}
    end
    
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
    
    MainMenu.mainMenu:draw()
    
    love.graphics.setFont(MainMenu.titleFont)
    
    love.graphics.print( "Enemu 3 : Lumenus", 80, 30 )
    
    love.graphics.setFont(font)
    
    

end

function MainMenu.keypressed(key)
    local result = MainMenu.mainMenu:keypressed(key)
    
    if result then
        if result ~= "abort" then
            if result.item.title == "Start" then
                gamestate:change("InGame")
            elseif result.item.title == "Load" then
            elseif result.item.title == "Fullscreen" then
                love.graphics.toggleFullscreen()
            elseif result.item.title == "Exit" then
                love.event.push("q")
                return
            end
        end
    end
end


return MainMenu