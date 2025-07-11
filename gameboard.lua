Gameboard = {
    grid = {},
}

love.graphics.setDefaultFilter('nearest', 'nearest')

-- Create a 600 x 800 array
grid = {}
for i = 1, 100 do
    grid[i] = {}

    for j = 1, 100 do
        grid[i][j] = {1,1,1} -- color
    end
end

time_of_completion = 0
complete = false

my_y = 100
my_x = 200
my_dy = -350
my_jump = false


function love.load()
    love.window.setTitle('Game Test')

    math.randomseed(os.time())

    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    if key == 'escape' then love.event.quit() end
    love.keyboard.keysPressed[key] = true
end

function keyPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    if my_y >= 585 then my_jump = true end
    if my_dy > -300 then my_dy = my_dy - 20 end

    love.keyboard.keysPressed = {}

    if not check_for_complete() then
        time_of_completion = time_of_completion + dt
    end

    if (my_y >= 585)then my_y = my_y + my_dy*dt end
    if (my_y < 585) then
        my_y = my_y - my_dy*dt
    end

    if love.keyboard.isDown('up') and my_jump then 
        my_y = math.max(my_y - (300*dt), 5) 
        my_dy = 200
        my_jump = false
    
        end
    if love.keyboard.isDown('e') then grid = rotate90() end
    if love.keyboard.isDown('down') then my_y = math.min(my_y + (300*dt), 585) end
    if love.keyboard.isDown('left') then my_x = math.max(my_x - (300*dt), 5) end
    if love.keyboard.isDown('right') then my_x = math.min(my_x + (300*dt), 785) end

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

            if (math.abs((my_x+5) - i * 8) <= 12 and math.abs((my_y+5) - j * 6) <= 12) then

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
    love.graphics.print(my_y .." : ".. my_x)

    love.graphics.print(time_of_completion, 0, 16)

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

function rotate90()
    local rows = #grid
    local cols = #grid[1]
    local rotated = {}

    for i = 1, cols do
        rotated[i] = {}
        for j = 1, rows do
            rotated[i][j] = grid[rows - j + 1][i]
        end
    end

    return rotated
end

function rotateNeg90()
    local rows = #grid
    local cols = #grid[1]
    local rotated = {}

    for i = 1, cols do
        rotated[i] = {}
        for j = 1, rows do
            rotated[i][j] = grid[j][cols - i + 1]
        end
    end

    grid = rotated
end