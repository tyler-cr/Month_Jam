require("statestack")
require("states/levelstate")
require("physics")
require("gameboard")
require("player")
require("graphics")
require("tiles")

love.graphics.setDefaultFilter('nearest', 'nearest')

-- TESTING AREA BEGIN
-- TESTING AREA END

function love.load()
    Grid.createBorder()
    love.window.setTitle('Game Test')
    math.randomseed(os.time())
    love.keyboard.keysPressed = {}
    Statestack.push(Level)
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
    Statestack.update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    love.graphics.setColor(1,1,1)
    Statestack.draw()
end