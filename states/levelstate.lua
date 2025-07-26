Level = {}

function Level.init()

    Level.objects = {Player}

    for i = 0, 12 do
        local test = Accelerator.init(Grid.leftwall+24*i, Grid.center.y)
        table.insert(Level.objects, test)
    end

    local test = Cannon.init(Grid.leftwall+64, Grid.floor)
    table.insert(Level.objects, test)

end

local fixed_dt = 1/60
local accumulator = 0

-- maybe remove the fixed_dt
function Level.update(dt)

    accumulator = accumulator + dt

    while accumulator >= fixed_dt do
        world:update(fixed_dt)
        accumulator = accumulator - fixed_dt
    end

    for _, val in pairs(Level.objects) do
        val.update(dt)
    end

    Grid.update(dt)

end

function Level.draw()
    
    for i = #Level.objects, 1, -1 do
        local val = Level.objects[i]
        if val.drawMe then val.draw() end
    end


    love.graphics.rectangle("line", Grid.leftwall, Grid.ceiling, Grid.length+24, Grid.width+24)

    love.graphics.print(math.floor(Player.my_x).." : "..math.floor(Player.my_y), 10, 10)
    love.graphics.print(math.floor(Player.my_dx).." : "..math.floor(Player.my_dy), 10, 20)
    love.graphics.print(math.floor(Player.highest), 10, 30)
    love.graphics.print(tostring(Player.grounded), 10, 40)

end
