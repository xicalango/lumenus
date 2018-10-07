-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local states = {
    InGame = require("states/ingame") ,
    Shop = require("states/shop"),
    GameOver = require("states/gameover"),
    MainMenu = require("states/mainmenu"),
    Pause = require("states/pause"),
--    LevelEnd = require("states/levelend")
}

return states
