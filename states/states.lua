-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

local states = {
    InGame = require("states/ingame.lua") ,
    Shop = require("states/shop.lua"),
    GameOver = require("states/gameover.lua"),
    MainMenu = require("states/mainmenu.lua"),
    Pause = require("states/pause.lua"),
}

return states