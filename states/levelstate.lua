function TableConcat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

require("mapmaker")

currentLevel = 1
nextLevelFlag = false

Level = {}

function Level.init()

    Level.objects = Level.loadLevel(currentLevel)
    table.insert(Level.objects, Player)

        --testing out blocks 
    -- for i = 0, 5 do
    --     if i%2 == 0 then 
    --         local test = Blackhole.init(Grid.leftwall+80*i+24, Grid.center.y)
    --         table.insert(Level.objects, test)
    --     else
    --         local test = Whitehole.init(Grid.leftwall+80*i+24, Grid.center.y)
    --         table.insert(Level.objects, test)
    --     end

    -- end

    -- local test = Cannon.init(Grid.leftwall+64, Grid.floor)
    table.insert(Level.objects, test)

end

--fixed_dt for physics to be more accurate
local fixed_dt = 1/60
local accumulator = 0

function Level.update(dt)

    if nextLevelFlag then
        currentLevel = currentLevel+1
        print(string.format("going to level %d. There are %d total levels. \n", currentLevel, #rooms))
        nextLevelFlag = false
        Level.physicsCleanUp()
        Level.init()
    end

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


function Level.loadLevel(i)
    --TODO: Grab rotation, flip, etc
    retTable = {}

    local level = rooms[i]
    for coords, blockID in pairs(level) do
        local x, y = coords:match("(%d+)%s*:%s*(%d+)")
        x, y = tonumber(x), tonumber(y)
        print(blockID)
        local newBlock = id_to_block(blockID).init(x, y)
        print(newBlock.name)
        table.insert(retTable, newBlock)
    end

    return retTable
end

function id_to_block(id)
    if id == 2      then return Computer
    elseif id == 3      then return Bouncer
    elseif id == 4      then return DirectionalDoor
    elseif id == 5      then return OneWayDoor
    elseif id == 6      then return OneWayDoor --TODO: this needs to be OpenDoor but that hasn't been implimented in tiles? 
    elseif id == 7      then return Cannon
    elseif id == 8      then return Teleport
    elseif id == 11     then return Spikes
    elseif id == 18     then return Ice
    elseif id == 19     then return FallAways
    elseif id == 20     then return Accelerator
    elseif id == 21     then return Glass
    elseif id == 23     then return Blackhole
    elseif id == 26     then return Whitehole
    else return Block
    end
end

function Level.physicsCleanUp()
    for _, body in ipairs(world:getBodies()) do
        local ud = body:getUserData()
        if not (ud and ud.name == "Player") then
            body:destroy()
        end
    end
    Grid.createBorder()
end