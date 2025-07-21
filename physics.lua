world  = love.physics.newWorld(0, 900)


function beginContact(a, b, coll)
    
end

function endContact(a, b, coll)

end

function preSolve(a, b, coll)

end

function postSolve(a, b, coll, normalImpulse, tangentImpulse)
    if Physics.collidedObjects(a, b, "Player", "Glass" and normalImpulse > Glass.breakAt then
            print("normalImpulse:", normalImpulse)
        end
end

world:setCallbacks(beginContact, endContact, preSolve, postSolve)

Physics = {}

function Physics.collidedObjects(a, b, string1, string2)
    local aString, bString = a:getUserData(), b:getUserData()

    return (aString == string1 and bString == string2) or (aString == string2 and bString == string1)
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
    obj.shape2 = love.physics.newRectangleShape(width/2, height/2, width, height)
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
end

function Physics.flipYaxis(obj)
    local vx, vy = obj.body:getLinearVelocity()
    obj.body:setLinearVelocity(-vx, vy)
end

