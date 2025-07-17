require("gameboard")
require("player")
require("graphics")
require("tiles")

love.graphics.setDefaultFilter('nearest', 'nearest')

time_of_completion = 0
complete = false

-- TESTING AREA BEGIN
local world  = love.physics.newWorld(0, 0)
Player.body  = love.physics.newBody(world, Player.my_x, Player.my_y, "dynamic")
Player.shape = love.physics.newRectangleShape(Block.size, Block.size)

-- TESTING AREA END

function love.load()

    love.window.setTitle('Game Test')

    math.randomseed(os.time())

    love.keyboard.keysPressed = {}
    


end

love.keyboard.keysPressed = {}

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function keyPressed(key)
    return love.keyboard.keysPressed[key]
end
function love.update(dt) 

    world:update(dt)

    if love.keyboard.isDown("escape") then love.event.quit() end

    if not check_for_complete() then
        time_of_completion = time_of_completion + dt
    end

    Player.update(dt)
    Grid.update(dt)

    love.keyboard.keysPressed = {}

end

function love.draw()
    
    love.graphics.rectangle("line", Grid.leftwall, Grid.ceiling, Grid.length+24, Grid.width+24)

    Player.draw()

    love.graphics.setColor(1,1,1)

    --BEGINNING OF TESTING AREA
    
    love.graphics.print(math.floor(Player.my_x).." : "..math.floor(Player.my_y), 10, 10)
    love.graphics.print(math.floor(Player.my_dx).." : "..math.floor(Player.my_dy), 10, 20)
    love.graphics.print(math.floor(Player.highest), 10, 30)


    --END OF TESTING AREA

end

function check_for_complete()
    for i, row in ipairs(grid) do
        for j, cell in ipairs(row) do
            if cell[1] == 1 and cell[2] == 1 and cell[3] == 1 then
                return false
            end
        end
    end
    return true
end

function format_time(t)
    local minutes = math.floor(t / 60)
    local seconds = math.floor(t % 60)
    return string.format("%02d:%02d", minutes, seconds)
end