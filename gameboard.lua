require("tiles")

-- for functions
Grid = {length = 480, width = 480}

Grid.center = {
    x = 400,
    y = 300
}

Grid.ceiling = Grid.center.y - 240
Grid.floor = Grid.center.y + 240
Grid.leftwall = Grid.center.x - 240
Grid.rightwall = Grid.center.x + 240


Grid.placementoffset = function(i) return (i-1) * Block.size end

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

function distancebetweenpoints(x1, x2, y1, y2)
    return math.sqrt((x2-x1)^2-(y2-y1)^2)
end

function slopebetweenpoints(x1, x2, y1, y2)
    if x2 == x1 then return 999 end -- if the points x vals are the same, we have to prevent devide by zero
    return (y2-y1)/(x2-x1)
end

function perpendicularslope(slope)
    return -1/slope
end

function Grid.quadrant(x, y)
    local xrel =  x - Grid.center.x
    local yrel =  Grid.center.y - y

    if      xrel > 0 and yrel > 0 then return "quad 1"
    elseif  xrel < 0 and yrel > 0 then return "quad 2"
    elseif  xrel < 0 and yrel < 0 then return "quad 3"
    else                               return "quad 4" end

end

function Grid.update(dt)
    Grid.handleMovement()
end

function Grid.handleMovement()
    if      keyPressed("q") then Grid.rotate90()
    elseif  keyPressed("e") then Grid.rotateneg90()
    elseif  keyPressed("w") or keyPressed("s") then Grid.flipXaxis()
    elseif  keyPressed("a") or keyPressed("d") then Grid.flipYaxis() end
end

function Grid.rotate90()
    Player.rotate90()
end

function Grid.rotateneg90()
    Player.rotateneg90()
end

function Grid.flipXaxis()
    Player.flipXaxis()
end

function Grid.flipYaxis()
    Player.flipYaxis()
end