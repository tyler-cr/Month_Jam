require ("physics")

function math.Clamp(val, lower, upper)
    assert(val and lower and upper, "not very useful error message here")
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end

Player = {

    name = "Player",

    drawMe = true,

    my_r = 0,
    my_restitution = .4,

    my_y = Grid.floor,
    my_x = Grid.center.x,
    my_dy = 0,
    my_dx = 0,
    highest = Grid.floor,

    draw = function() drawTile(tileset.tile.player_active, Player) end,

    -- these will be used when flipped and rotating. Don't get updated unless called in function
    relative_x = 0,
    relative_y = 0,

    -- holds movement values
    dx = {max = {}},
    dy = {max = {}},

    touching_left_wall = function () return Player.my_x <= Grid.leftwall   end,
    touching_right_wall= function () return Player.my_x >= Grid.rightwall end,

    grounded = false
}

Physics.createRectangle(Player, "dynamic", Block.size,Block.size)
Player.fixture:setUserData(Player)
Player.fixture:setRestitution(0)

Player.dx.max.walk = 210
Player.dy.max.jump = 500
Player.dy.jump = -180
Player.dy.speedfall = 5
Player.dx.walljump = 500
Player.dx.walk = 5
Player.dx.stall = 25
Player.gravity = 2
Player.killMe = false
Player.teleport = false

function Player.update(dt)

    if Player.killMe then Player.die() end
    if Player.teleport then 
        Physics.setPosn(Player)
        Player.teleport = false
    end

    if Player.my_y >= Grid.floor then Player.grounded = false end

    Player.handlemovement(dt)

end

function Player.draw()
    drawTile(tileset.tile.player_active, Player, Player.my_r)
end

function Player.handlemovement(dt)
    Player.my_dx = 0
    Player.my_dy = 0

    local testVeloX, testVeloY = Player.body:getLinearVelocity()
    testVeloX = testVeloX/40

    Player.my_r = Player.my_r + dt*testVeloX

    if love.keyboard.isDown("left") then
        Player.my_dx = -Player.dx.walk
    elseif love.keyboard.isDown("right") then
        Player.my_dx = Player.dx.walk
    end

    if keyPressed("up") and Player.grounded then
        Player.my_dy = Player.dy.jump
        Player.grounded = false
    end

    Player.body:applyLinearImpulse(Player.my_dx, Player.my_dy)
    Player.my_x, Player.my_y = Player.body:getPosition()
end

function Player.resetlocation()
    Player.my_y = Grid.center.x
    Player.my_x = Grid.center.y
    Player.my_dy = 350
    Player.my_dx = 0
end

function Player.setrelative()

    Player.relative_x =  Player.my_x - Grid.center.x
    Player.relative_y =  Player.my_y - Grid.center.y

end

function Player.setcoordfromrelative()
    Player.my_x = Player.relative_x + Grid.center.x
    Player.my_y = Player.relative_y + Grid.center.y
end

function Player.rotate90()

    Player.setrelative()

    local old_relative_x = Player.relative_x
    local old_relative_y = Player.relative_y

    Player.relative_x = old_relative_y
    Player.relative_y = -old_relative_x

    Player.setcoordfromrelative()
    Physics.setPosn(Player)
    Physics.rotate90(Player)

end

function Player.rotateneg90()

    Player.setrelative()

    local old_relative_x = Player.relative_x
    local old_relative_y = Player.relative_y

    Player.relative_x = -old_relative_y
    Player.relative_y = old_relative_x

    Player.setcoordfromrelative()
    Physics.setPosn(Player)
    Physics.rotateneg90(Player)

end

function Player.flipXaxis()

    Player.setrelative()

    Player.relative_y = -Player.relative_y
    Player.setcoordfromrelative()
    Physics.setPosn(Player)
    Physics.flipXaxis(Player)

end

function Player.flipYaxis()
    Player.setrelative()

    Player.relative_x = -Player.relative_x
    Player.setcoordfromrelative()
    Physics.setPosn(Player)
    Physics.flipYaxis(Player)
end

function Player.die()
    Player.my_dx = 0
    Player.my_dy = 0
    Player.my_y = Grid.floor
    Player.my_x = Grid.center.x

    Player.body:setLinearVelocity(0,0)
    Player.body:setPosition(Player.my_x, Player.my_y)

    Player.killMe = false
end