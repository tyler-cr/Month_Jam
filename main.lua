require("statestack")
require("states/levelstate")
require("states/startstate")
require("states/editorstate")
require("physics")
require("gameboard")
require("player")
require("graphics")
require("tiles")
require("states/cannonstate")
require("timer")
require("mapmaker")
require ("rooms")


love.graphics.setDefaultFilter('nearest', 'nearest')
-- TESTING AREA BEGIN
local curFastestX, curFastestY = 0,0

-- TESTING AREA END

function love.load()
    Grid.createBorder()
    love.window.setTitle('Game Test')
    math.randomseed(os.time())
    love.keyboard.keysPressed = {}
    Statestack.push(Start)
end

love.keyboard.keysPressed = {}

function love.keypressed(key)
    table.insert(love.keyboard.keysPressed, key)
    love.keyboard.keysPressed[key] = true
end

function keyPressed(key)
    return love.keyboard.keysPressed[key]
end

function getKey() return love.keyboard.keysPressed[1] end
function getKeys()return love.keyboard.keysPressed end

function love.update(dt)
    
    if keyPressed("p") then 
        print("why no work") 
    end

    Timer.timekeeper()

    local curVX, curVY = Player.body:getLinearVelocity()

    if math.abs(curVX) > math.abs(curFastestX) then curFastestX = math.abs(curVX) end
    if math.abs(curVY) > math.abs(curFastestY) then curFastestY = math.abs(curVY) end

    Statestack.update(dt)


    love.keyboard.keysPressed = {}

end

function love.draw()
    love.graphics.setColor(.2,.2,.2)
    love.graphics.rectangle("fill", 0,0,800, 600)
    love.graphics.setColor(1,1,1)

    Statestack.draw()
end