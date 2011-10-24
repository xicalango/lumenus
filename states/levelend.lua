-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local LevelEnd = {}
LevelEnd.__index = LevelEnd

function LevelEnd.draw()

    gamestate:foreignCall("InGame","draw")

end

function LevelEnd.update(dt)
	player:update(dt)	
end

function LevelEnd.keypressed(key)
    if key == "escape" then
        gamestate:change("InGame")
    end
end



return Pause
