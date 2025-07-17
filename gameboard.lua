-- Create a 600 x 800 array
grid = {}
for i = 1, 20 do
    grid[i] = {}

    for j = 1, 20 do
        grid[i][j] = nil
    end
end

-- for i = 1, 20 do
--     grid[i] = Block.init()
-- end


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
    elseif  keyPressed("w") or keyPressed("s") then Grid.flipX()
    elseif  keyPressed("a") or keyPressed("d") then Grid.flipY() end
end

function Grid.rotate90()
    local rows = #grid
    local cols = #grid[1]
    local rotated = {}

    for i = 1, cols do
        rotated[i] = {}
        for j = 1, rows do
            rotated[i][j] = grid[rows - j + 1][i]
        end
    end

    grid = rotated

    Player.rotate90()

end

function Grid.rotateneg90()
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

    Player.rotateneg90()

end

function Grid.flipX()
    for _, row in ipairs(grid) do
        local i, j = 1, #row
        while i < j do
            row[i], row[j] = row[j], row[i]
            i = i + 1
            j = j - 1
        end
    end
    Player.flipDY()
end

function Grid.flipY()
    local i, j = 1, #grid
    while i < j do
        grid[i], grid[j] = grid[j], grid[i]
        i = i + 1
        j = j - 1
    end
    Player.flipDX()
end