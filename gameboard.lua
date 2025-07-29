require("tiles")

-- for functions
Grid = {length = 480, width = 480, midOffset = 240}

Grid.center = {
    x = 400,
    y = 300
}

Grid.ceiling = Grid.center.y - Grid.midOffset
Grid.floor = Grid.center.y + Grid.midOffset
Grid.leftwall = Grid.center.x - Grid.midOffset
Grid.rightwall = Grid.center.x + Grid.midOffset


Grid.border = {top = {name = "Grid.border.top"}, bottom = {name = "Grid.border.bottom"},
                      left = {name = "Grid.border.left"}, right = {name = "Grid.border.right"}}

function Grid.createBorder()
    Grid.border.top.body = love.physics.newBody(world, Grid.leftwall, Grid.ceiling, "static")
    Grid.border.top.shape = love.physics.newRectangleShape(Grid.width/2, 1, Grid.width, 1)
    Grid.border.top.fixture = love.physics.newFixture(Grid.border.top.body, Grid.border.top.shape)
    Grid.border.top.fixture:setUserData(Grid.border.top)

    Grid.border.left.body = love.physics.newBody(world, Grid.leftwall, Grid.ceiling, "static")
    Grid.border.left.shape = love.physics.newRectangleShape(0, Grid.length/2, 1, Grid.length)
    Grid.border.left.fixture = love.physics.newFixture(Grid.border.left.body, Grid.border.left.shape)
    Grid.border.left.fixture:setUserData(Grid.border.left)

    Grid.border.bottom.body = love.physics.newBody(world, Grid.leftwall, Grid.floor+24, "static")
    Grid.border.bottom.shape = love.physics.newRectangleShape(Grid.width/2, 0, Grid.width+24, 1)
    Grid.border.bottom.fixture = love.physics.newFixture(Grid.border.bottom.body, Grid.border.bottom.shape)
    Grid.border.bottom.fixture:setUserData(Grid.border.bottom)
    Grid.border.bottom.fixture:setFriction(0.1)

    Grid.border.right.body = love.physics.newBody(world, Grid.rightwall+24, Grid.ceiling, "static")
    Grid.border.right.shape = love.physics.newRectangleShape(0, Grid.length/2, 1, Grid.length+24)
    Grid.border.right.fixture = love.physics.newFixture(Grid.border.right.body, Grid.border.right.shape)
    Grid.border.right.fixture:setUserData(Grid.border.right)
end