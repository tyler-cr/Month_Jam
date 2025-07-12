-- Create a 600 x 800 array
grid = {}
for i = 1, 100 do
    grid[i] = {}

    for j = 1, 100 do
        grid[i][j] = {1,1,1} -- color
    end
end

-- for functions
Grid = {}

function Grid.update(dt)
    Grid.handleMovement()
end

function Grid.handleMovement()
    if      keyPressed("e") then Grid.rotate90()
    elseif  keyPressed("q") then Grid.rotateneg90()
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
end

function Grid.flipY()
    local i, j = 1, #grid
    while i < j do
        grid[i], grid[j] = grid[j], grid[i]
        i = i + 1
        j = j - 1
    end
end