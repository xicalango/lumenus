-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

function love.conf(t)
	t.title = "Lumenus"
    t.author = "Alexander Weld"
    t.console = false --for debuging

    t.modules.physics = false -- don't need that

    t.screen.width=640
    t.screen.height=480
end
