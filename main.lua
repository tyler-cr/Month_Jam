require("gameboard")
require("player")
require("graphics")
require("tiles")

love.graphics.setDefaultFilter('nearest', 'nearest')

time_of_completion = 0
complete = false



-- TESTING AREA BEGIN

local border = {
    top = {}, bottom = {}, left = {}, right = {}
}

testBlock = Block.init(200,100)
local world  = love.physics.newWorld(0, 900)

function createRectanglePhysics(obj, type)
    obj.body     = love.physics.newBody(world, obj.my_x, obj.my_y, type)
    obj.shape    = love.physics.newRectangleShape(Block.size/2,Block.size/2, Block.size, Block.size)
    obj.fixture  = love.physics.newFixture(obj.body, obj.shape)
    obj.body:setFixedRotation(true)
end

function createBorder()
    border.top.body = love.physics.newBody(world, Grid.leftwall, Grid.ceiling, "static")
    border.top.shape = love.physics.newRectangleShape(Grid.width/2, 1, Grid.width, 1)
    border.top.fixture = love.physics.newFixture(border.top.body, border.top.shape)

    border.left.body = love.physics.newBody(world, Grid.leftwall, Grid.ceiling, "static")
    border.left.shape = love.physics.newRectangleShape(0, Grid.length/2, 1, Grid.length)
    border.left.fixture = love.physics.newFixture(border.left.body, border.left.shape)

    border.bottom.body = love.physics.newBody(world, Grid.leftwall, Grid.floor+24, "static")
    border.bottom.shape = love.physics.newRectangleShape(Grid.width/2, 0, Grid.width+24, 1)
    border.bottom.fixture = love.physics.newFixture(border.bottom.body, border.bottom.shape)

    border.right.body = love.physics.newBody(world, Grid.rightwall+24, Grid.ceiling, "static")
    border.right.shape = love.physics.newRectangleShape(0, Grid.length/2, 1, Grid.length+24)
    border.right.fixture = love.physics.newFixture(border.right.body, border.right.shape)
end

createRectanglePhysics(Player, "dynamic")
createRectanglePhysics(testBlock, "static")

-- TESTING AREA END

function love.load()

    createBorder()

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
    love.graphics.print(tostring(Player.can_jump()), 10, 40)

    testBlock.draw()

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