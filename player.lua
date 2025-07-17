function math.Clamp(val, lower, upper)
    assert(val and lower and upper, "not very useful error message here")
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end

Player = {
    my_y = Grid.center.y,
    my_x = Grid.center.x,
    my_dy = 350,
    my_dx = 0,

    draw = function() drawTile(tileset.tile.player_active, Player) end,

    -- these will be used when flipped and rotating. Don't get updated unless called in function
    relative_x = 0,
    relative_y = 0,

    -- holds movement values
    dx = {max = {}},
    dy = {max = {}},

    touching_left_wall = function () return Player.my_x <= Grid.leftwall   end,
    touching_right_wall= function () return Player.my_x >= Grid.rightwall end,

    can_jump = function ()  return (Player.my_y >= Grid.floor or Player.touching_left_wall() or Player.touching_right_wall()) end
}

Player.dx.max.walk = 700
Player.dy.max.jump = 500
Player.dy.jump = -450
Player.dy.speedfall = 20
Player.dx.walljump = 500
Player.dx.walk = 50
Player.dx.stall = 25
Player.dx.floorfriction = .9
Player.gravity = 20

function Player.update(dt)
    Player.handlemovement(dt)
end

function Player.draw()
    drawTile(tileset.tile.player_active, Player)
end

function Player.deltaupdate(dx, dy, maxDX, maxDY)
    Player.my_dy = Player.my_dy + dy
    Player.my_dx = Player.my_dx + dx

    if maxDY and math.abs(Player.my_dy) > maxDY then
        Player.my_dy = maxDY * (Player.my_dy > 0 and 1 or -1)
    end
    if maxDX and math.abs(Player.my_dx) > maxDX then
        Player.my_dx = maxDX * (Player.my_dx > 0 and 1 or -1)
    end
end



function Player.deltaoverride(dx, dy)
    Player.my_dy = dy
    Player.my_dx = dx
end

function Player.handlejump()
    Player.deltaupdate(0, Player.dy.jump)
    if Player.touching_left_wall() then 
        Player.deltaoverride(Player.dx.walljump, Player.dy.jump)
    elseif Player.touching_right_wall() then
        Player.deltaoverride(-Player.dx.walljump, Player.dy.jump)
    end
end

function Player.handlemovement(dt)

    --gravity
    if Player.my_y > Grid.ceiling and Player.my_y <= Grid.floor then Player.deltaupdate(0, Player.gravity) end
    if Player.my_y >= Grid.floor then Player.deltaoverride(Player.my_dx, 0) end
    if Player.my_y <= Grid.ceiling then Player.deltaoverride(Player.my_dx, Player.gravity) end


    if (keyPressed("up") and Player.can_jump()) then
         Player.handlejump() end

    if love.keyboard.isDown('down') then 
        Player.deltaupdate(0, Player.dy.speedfall) end

    if love.keyboard.isDown('left') then
        Player.deltaupdate(-Player.dx.walk, 0, Player.dx.max.walk)
    elseif love.keyboard.isDown('right') then 
        Player.deltaupdate(Player.dx.walk, 0, Player.dx.max.walk)
    else
        if   math.abs(Player.my_dx) <= Player.dx.stall then  Player.my_dx = 0
        else Player.my_dx = Player.my_dx * Player.dx.floorfriction end

    end

    Player.my_y = math.Clamp(Player.my_y + Player.my_dy*dt, Grid.ceiling, Grid.floor)
    Player.my_x = math.Clamp(Player.my_x + Player.my_dx*dt, Grid.leftwall, Grid.rightwall)

end

function Player.flipDX()
    Player.my_dx = -Player.my_dx
end

function Player.flipDY()
    Player.my_dy = -Player.my_dy
end

function Player.getadjacentblocks()

end

function Player.resetlocation()
    Player.my_y = Grid.center.x
    Player.my_x = Grid.center.y
    Player.my_dy = 350
    Player.my_dx = 0
end

function Player.outofbounds()
    if Player.my_x > grid.right or Player.my_x < grid.left or Player.my_y < grid.ceiling or Player.my_y > grid.floor then
        Player.my_x = math.Clamp(Player.my_x, grid.left, grid.right)
        Player.my_y = math.Clamp(Player.my_y, grid.ceiling, grid.floor)
    end

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

end

function Player.rotateneg90()

    Player.setrelative()

    local old_relative_x = Player.relative_x
    local old_relative_y = Player.relative_y

    Player.relative_x = -old_relative_y
    Player.relative_y = old_relative_x

    Player.setcoordfromrelative()

end


--todo: when player collides with certain blocks, will reset level
function Player.die()
end