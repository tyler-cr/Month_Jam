require("player")
require("gameboard")

love.graphics.setDefaultFilter('nearest', 'nearest')

time_of_completion = 0
complete = false

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

    if love.keyboard.isDown("escape") then love.event.quit() end

    if not check_for_complete() then
        time_of_completion = time_of_completion + dt
    end

    Player.update(dt)
    Grid.update(dt)

    love.keyboard.keysPressed = {}

end

function love.draw()
    if check_for_complete() then
        love.graphics.print(format_time(time_of_completion))
        return
    end
    -- Draw the grid
    for i = 1, 100 do
        for j = 1, 100 do


            love.graphics.setColor(0.5, 0.5, 0.5)

            if (math.abs((Player.my_x+5) - i * 8) <= 12 and math.abs((Player.my_y+5) - j * 6) <= 12) then

                grid[i][j][1] = 1
                grid[i][j][2] = 1
                grid[i][j][3] = 0

                love.graphics.setColor(grid[i][j][1], grid[i][j][2], grid[i][j][3])
                love.graphics.rectangle("line", 8*(i-1)+3, 6*(j-1)+3, 5, 5)
            else 
                love.graphics.setColor(grid[i][j][1], grid[i][j][2], grid[i][j][3])
                love.graphics.rectangle("line", 8*(i-1)+5, 6*(j-1), 3, 3) end
        end
    end
    
    love.graphics.setColor(1,1,1)
    -- love.graphics.rectangle("fill", my_x, my_y, 10, 10)
    love.graphics.print(tostring(Player.can_jump()))

    love.graphics.print(time_of_completion, 0, 16)

    local test = string.format("%02d:%02d", Player.my_x, Player.my_y)
    local test2= string.format("%02d:%02d", Player.relative_x, Player.relative_y) 
    love.graphics.print(test, 0, 32)
    love.graphics.print(test2, 0, 48)

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