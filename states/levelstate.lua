Level = {}

function Level.init()
    Level.objects = {Player}
end

function Level.update(dt)

    world:update(dt)
    Player.update(dt)
    Grid.update(dt)

end

function Level.draw()
    for _, val in pairs(Level.objects) do
        val.draw()
    end

    love.graphics.rectangle("line", Grid.leftwall, Grid.ceiling, Grid.length+24, Grid.width+24)

    love.graphics.print(math.floor(Player.my_x).." : "..math.floor(Player.my_y), 10, 10)
    love.graphics.print(math.floor(Player.my_dx).." : "..math.floor(Player.my_dy), 10, 20)
    love.graphics.print(math.floor(Player.highest), 10, 30)
    love.graphics.print(tostring(Player.grounded()), 10, 40)

end
