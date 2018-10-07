-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

util = {}
util.__index = util

function util.interpolateColor(colorFrom, colorTo, p)
    local icolor = {}
    
    for i,v in ipairs(colorFrom) do
        icolor[i] = (p * (colorFrom[i] - colorTo[i])) + colorTo[i]
    end

    return icolor
end

function util.takeRandom(tbl)
    return tbl[math.random(1,#tbl)]
end

function util.capitalize(word)
    return string.gsub(word, "(.)(.*)",
        function(head, tail)
                return string.upper(head) .. string.lower(tail)
        end
        )
end

function util.filter(tbl, filter)
    local result = {}
    
    for k, v in pairs(tbl) do
        if filter(v,k) then
            result[k] = v
        end
    end

    return result
end

function util.map(tbl, fn)
    local result = {}
    
    for k,v in pairs(tbl) do
        result[k] = fn(v,k)
    end
    
    return result
end

function util.keycheck(needle,haystack) --only for small haystacks

    if type(haystack) == "table" then

        for i,v in ipairs(haystack) do
            if v == needle then
                return true
            end
        end
    else
        return haystack == needle
    end
    
    return false
end

function util.sign(v)
    if v < 0 then
        return -1
    elseif v > 0 then
        return 1
    else
        return 0
    end
end

function util.dir( fx, fy, tx, ty )
	return util.sign(tx-fx), util.sign(ty-fy)
end

function util.move( dt, x, y, dx, dy, speedx, speedy )
    return x + dx * speedx * dt, y + dy * (speedy or speedx) * dt
end

function util.moveDir( x, y, phi, speed, dt )
    local dx = speed * math.cos(phi)
    local dy = speed * math.sin(phi)
    
    return x + dx * dt, y + dy * dt
end

function util.drawGraphic( graphics, x, y, viewX, viewY, phi, tintOverride )
    local viewX = viewX or x
    local viewY = viewY or y-1
    
    phi = phi or math.atan2(viewY - y, viewX - x) + math.rad(90)
    
    local offset = graphics.offset or {0,0}
    
    local _r,_g,_b,_a = love.graphics.getColor()
    
    if tintOverride then
        love.graphics.setColor(tintOverride)
    elseif graphics.tint then
        love.graphics.setColor(graphics.tint)
    end
    
    love.graphics.draw( 
        graphics.image, 
        x, y, 
        phi , 
        graphics.scaleX or 1, 
        graphics.scaleY or graphics.scaleX, 
        offset[1], offset[2] )
        
    love.graphics.setColor(_r,_g,_b,_a)
end

function util.collide(x, y, sx, sy, graphic, border)
    border = border or 0
    local offsetX = graphic.offsetX*(graphic.scaleX or 1)+border
    local offsetY = graphic.offsetY*(graphic.scaleY or 1)+border

    if x > sx-offsetX and x < sx+offsetX and y > sy-offsetY and y < sy+offsetY then
        return true
    end
    return false
end

function util.getVertices(x,y,graphic,border)
    border = border or 0
    local offsetX = graphic.offsetX*(graphic.scaleX or 1)+border
    local offsetY = graphic.offsetY*(graphic.scaleY or 1)+border
    
    local vertices = {}
    
    vertices[1] = { x = x-offsetX, y = y-offsetY }
    vertices[2] = { x = x-offsetX, y = y+offsetY }
    vertices[3] = { x = x+offsetX, y = y-offsetY }
    vertices[4] = { x = x+offsetX, y = y+offsetY }
    
    return vertices
end

function util.configurePS( def )
    local ps = love.graphics.newParticleSystem(def.image, def.nMax)
    
    ps:setEmissionRate(def.emissionRate)
    
    if def.size ~= nil then
    	ps:setSizes( def.size[1], def.size[2] )
    end

    
    if def.gravity ~= nil then
        ps:setLinearAcceleration(def.gravity)
    end
    
    if def.color ~= nil then
    
        if #def.color == 4 then
            ps:setColors(def.color[1], def.color[2], def.color[3], def.color[4])
        elseif #def.color == 8 then
            ps:setColors(def.color[1], def.color[2], def.color[3], def.color[4], def.color[5], def.color[6], def.color[7], def.color[8])
        end
    
    end
    
    if def.particleLife ~= nil then
        ps:setParticleLife(def.particleLife)
    end
    
    if def.lifetime ~= nil then
        ps:setLifetime(def.lifetime)
    end
    
    if def.speed ~= nil then 
        ps:setSpeed(def.speed[1], def.speed[2]) 
    end
    
    if def.spread ~= nil then
        ps:setSpread(def.spread)
    end
    
    if def.spin ~= nil then
        ps:setSpin(def.spin[1], def.spin[2])
    end
    
    if def.radialAcc ~= nil then
        ps:setRadialAcceleration( def.radialAcc[1], def.radialAcc[2] )
    end

    if def.tangentAcc ~= nil then
        ps:setTangentialAcceleration( def.tangentAcc[1], def.tangentAcc[2] )
    end
    
    return ps
end

function util.dstsq( x1, y1, x2, y2 )
    local dx = x2-x1
    local dy = y2-y1
    return dx*dx + dy*dy
end
