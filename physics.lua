world  = love.physics.newWorld(0, 900)

flipped = false

function beginContact(a, b, coll)
    local dataA = a:getUserData()
    local dataB = b:getUserData()
    local nx, ny = coll:getNormal()

    local player    = dataA.name == "Player" and dataA or dataB
    local nonplayer = dataA.name == "Player" and dataB or dataA

    local isPlayerA = dataA == "Player"

    if isPlayerA and ny < -.5 and (dataA.name ~= "Wall" or dataB.name ~= "Wall") then Player.grounded = true
    elseif ny > 0.5 then Player.grounded = true end

    if Physics.collidedObjects(a, b, "Player", "Glass") then
        local glass = a:getUserData() == "Glass" and a or b
        Physics.glassCollision(nx, ny, glass)

    elseif Physics.collidedObjects(a, b, "Player", "Computer") then
        print("LEVEL COMPLETE!!!")
        -- TODO

    elseif Physics.collidedObjects(a, b, "Player", "Bouncer") then

        local plX, plY = Player.body:getLinearVelocity()
        local newVy = math.min(Player.dy.jump*2, -plY)
        if isPlayerA and ny < -.5 or ny > 0.5 then Player.body:applyLinearImpulse(0, newVy) 
            Player.grounded = false
        end

    elseif Physics.collidedObjects(a, b, "Player", "Spikes") then
        Player.killMe = true

    elseif Physics.collidedObjects(a, b, "Player", "Cannon") then
        CannonState.cannon = nonplayer
        Statestack.push(CannonState)
    end

end

function endContact(a, b, coll)

    if Physics.collidedObjects(a, b, "Player", "Block") then
        Player.grounded = false
    end
end

function preSolve(a, b, coll)
    local dataA = a:getUserData()
    local dataB = b:getUserData()

    local vx, _ = Player.body:getLinearVelocity()
 
    local player = dataA == "Player" and dataA or dataB
    local other = dataA == "Player" and dataB or dataA

    if Physics.collidedObjects(a, b, "Player", "Blackhole") then
        coll:setEnabled(false)
    end

    if Physics.collidedObjects(a, b, "Player", "OneWayDoor") then
        if vx > 0 then coll:setEnabled(false) end
    end

    if Physics.collidedObjects(a, b, "Player", "DirectionalDoor") then
        if flipped then coll:setEnabled(false) end
    end

end

function postSolve(a, b, coll)
    if Physics.collidedObjects(a, b, "Player", "Cannon") then
        coll:setEnabled(false)
    end
end


world:setCallbacks(beginContact, endContact, preSolve, postSolve)

Physics = {}

function Physics.getProjectedImpactSpeed(vxA, vyA, nx, ny)
    local relVn = vxA * nx + vyA * ny
    local vB = relVn
    return math.abs(vB)
end

function Physics.glassCollision(nx, ny, glass)
    local vx, vy = Player.body:getLinearVelocity()

    if Physics.getProjectedImpactSpeed(vx, vy, nx, ny) > 300 then
        glass:getBody():destroy()
    end
end

function Physics.collidedObjects(a, b, string1, string2)
    local dataA, dataB = a:getUserData(), b:getUserData()

    return (dataA.name == string1 and dataB.name == string2) or (dataA.name == string2 and dataB.name == string1)
end

function Physics.createRectangle(obj, type, width, height)

    local new_shape_width  = width or  Block.size
    local new_shape_height = height or Block.size
    local new_shape_type = type or "static"

    obj.body     = love.physics.newBody(world, obj.my_x, obj.my_y, new_shape_type)
    obj.shape    = love.physics.newRectangleShape(new_shape_width/2, new_shape_height/2, new_shape_width, new_shape_height)
    obj.fixture  = love.physics.newFixture(obj.body, obj.shape)
    obj.body:setFixedRotation(true)

end

function Physics.addRectangle(obj, xOffset, yOffset, width, height)
    obj.shape2 = love.physics.newRectangleShape(width/2+xOffset, height/2-yOffset, width, height)
    obj.fixture2  = love.physics.newFixture(obj.body, obj.shape2)
end

function Physics.createCircle(obj, type, radius)
    new_radius = radius or Block.size

    obj.body     = love.physics.newBody(world, obj.my_x, obj.my_y, type)
    obj.shape    = love.physics.newCircleShape(new_radius/2, new_radius/2, new_radius)
    obj.fixture  = love.physics.newFixture(obj.body, obj.shape)
    obj.body:setFixedRotation(true)
end

function Physics.setPosn(obj)
    obj.body:setPosition(obj.my_x, obj.my_y)
end

function Physics.rotateneg90(obj)
    local vx, vy = obj.body:getLinearVelocity()
    local new_vx, new_vy = -vy, vx

    obj.body:setLinearVelocity(new_vx, new_vy)
end

function Physics.rotate90(obj)
    local vx, vy = obj.body:getLinearVelocity()
    local new_vx, new_vy = vy, -vx

    obj.body:setLinearVelocity(new_vx, new_vy)
end

function Physics.flipXaxis(obj)
    local vx, vy = obj.body:getLinearVelocity()
    obj.body:setLinearVelocity(vx, -vy)

    flipped = not flipped
end

function Physics.flipYaxis(obj)
    local vx, vy = obj.body:getLinearVelocity()
    obj.body:setLinearVelocity(-vx, vy)

    flipped = not flipped
end

