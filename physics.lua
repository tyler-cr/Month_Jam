world  = love.physics.newWorld(0, 900)

Physics = {}

function Physics.createRectangle(obj, type, width, height)

    local new_shape_width  = width or  Block.size
    local new_shape_height = height or Block.size
    local new_shape_type = type or "static"


    obj.body     = love.physics.newBody(world, obj.my_x, obj.my_y, new_shape_type)
    obj.shape    = love.physics.newRectangleShape(new_shape_width/2, new_shape_height/2, new_shape_width, new_shape_height)
    obj.fixture  = love.physics.newFixture(obj.body, obj.shape)
    obj.body:setFixedRotation(true)
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

