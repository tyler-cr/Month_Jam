require("util")
require("graphics")
require("timer")

Editor = {}


local mouseX, mouseY = love.mouse.getPosition()

local   mouseCircleSize = {default = 7, click = 5}

function Editor.init()
    mouseSelected = nil
    clickTimer = Timer.simple(0) --init as timer so we don't have nil issues

    mouseCircleSize.current = 7
    Editor.level = {}

    selectables = {}

    local tile = 1
    local drawY = 48
    local drawX = 32

    for i = 1, 5 do
        for j = 1, 3 do
            if      tile == 12 then tile = 18
            elseif  tile == 22 then tile = 23
            elseif  tile == 24 then tile = 26 end

            local new_block = Editor.blockInit(tile, drawX*(j)+20, drawY*(i)+64)
            table.insert(selectables, new_block)
            tile = tile + 1
        end
    end

end

function Editor.update(dt)

    if mouseSelected then
        mouseSelected.x = mouseX-Block.size/2
        mouseSelected.y = mouseY-Block.size/2
    end

    local mX = love.mouse.isDown(1)

    mouseX, mouseY = love.mouse.getPosition()


    if keyPressed("escape") then
        Statestack.pop()
        Statestack.push(Start)
    end

    if mX and clickTimer() then 
        clickTimer = Timer.simple(.2)
        mouseCircleSize.current = mouseCircleSize.click

        if mouseSelected then 
            mouseSelected = nil 
        
        else
            for _, block in pairs(selectables) do
                if block.collides(mouseX, mouseY) then 
                    local selected_block = Editor.blockInit(block.tile_i, mouseX-Block.size/2, mouseY-Block.size/2)
                    --table.insert(selectables, selected_block)
                    mouseSelected = selected_block
                    print("selection attempted")
                    break
                end
            end
        end
        
    else mouseCircleSize.current = mouseCircleSize.default end
    
end

function Editor.draw()
    
Editor.drawTileSquare()

    if mouseSelected then 
        mouseSelected.draw() 
    end

    love.graphics.rectangle("line", Grid.leftwall, Grid.ceiling, Grid.length+24, Grid.width+24)
    Editor.drawTiles()
    love.graphics.setColor(1,1,1)
    love.graphics.circle("fill", mouseX, mouseY, mouseCircleSize.current, mouseCircleSize.current)

end

function Editor.drawTiles()

    local drawY = 48
    local drawX = 32

    for _, block in pairs(selectables) do
        
        if block.collides() then
            love.graphics.setColor(0,.2,1,.6)
        else 
            love.graphics.setColor(1,.5,.25,.2)
        end
        
        love.graphics.rectangle("fill", block.x, block.y, Block.size, Block.size)
        love.graphics.setColor(1,1,1,1)
        block.draw()

    end 

end

function Editor.blockInit(tile, xval, yval)

    local block = {
        x = xval,
        y = yval,
        tile_i = tile
    }
    block.draw      =   function() drawTile_Editor(block.tile_i, block.x, block.y) end
    block.collides  =   function() return AABB(mouseX, mouseX, mouseY, mouseY, block.x, block.x+Block.size, block.y, block.y+Block.size) end
    
    return block

end

function Editor.saveLevel(filename)

end

function Editor.drawTileSquare()

    local xval = math.max((math.floor((mouseX)/24+.5))*24, Grid.leftwall)
    local yval = math.max((math.floor((mouseY)/24+.5))*24, Grid.ceiling)

    love.graphics.rectangle("line", xval, yval, 24, 24)
end