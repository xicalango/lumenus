
local Shop = {}
Shop.__index = Shop

function Shop.load()
end

function Shop.onActivation()
end

function Shop.update(dt)
end

function Shop.draw()
end

function Shop.keypressed(key)
    player:keypressed(key)
end

function Shop.keyreleased(key)
    player:keyreleased(key)
end

return Shop