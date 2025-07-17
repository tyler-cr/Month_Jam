require("player")
require("gameboard")
require("graphics")
require("tiles")

love.graphics.setDefaultFilter('nearest', 'nearest')

time_of_completion = 0

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

    Player.draw()

    love.graphics.setColor(1,1,1)

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