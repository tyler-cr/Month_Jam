function TableConcat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

require("mapmaker")

Level = {}

function Level.init()

    Level.objects = {Player}

        --testing out blocks 
    for i = 0, 5 do
        if i%2 == 0 then 
            local test = Blackhole.init(Grid.leftwall+80*i+24, Grid.center.y)
            table.insert(Level.objects, test)
        else
            local test = Whitehole.init(Grid.leftwall+80*i+24, Grid.center.y)
            table.insert(Level.objects, test)
        end

    end




    Level.objects = TableConcat(Level.objects, MapMaker.generateTableFromPath("images/testlevel.png"))

    local test = Cannon.init(Grid.leftwall+64, Grid.floor)
    table.insert(Level.objects, test)

end

--fixed_dt for physics to be more accurate
local fixed_dt = 1/60
local accumulator = 0

function Level.update(dt)

    if love.keyboard.isDown("escape") then 
        Statestack.pop()
        Statestack.push(Start)
     end

    accumulator = accumulator + dt

    while accumulator >= fixed_dt do
        world:update(fixed_dt)
        accumulator = accumulator - fixed_dt
    end

    for i, val in pairs(Level.objects) do
        if val.body:isDestroyed() then table.remove(Level.objects, i) end
        val.update(dt)
    end

end

function Level.draw()

    for i = #Level.objects, 1, -1 do
        local val = Level.objects[i]
        if val.drawMe then val.draw() end
    end


    love.graphics.rectangle("line", Grid.leftwall, Grid.ceiling, Grid.length+24, Grid.width+24)

    love.graphics.print(math.floor(Player.my_x).." : "..(Player.my_y), 10, 10)
    love.graphics.print(math.floor(Player.my_dx).." : "..math.floor(Player.my_dy), 10, 20)
    love.graphics.print(math.floor(Player.highest), 10, 30)
    love.graphics.print(tostring(Player.grounded), 10, 40)

end
