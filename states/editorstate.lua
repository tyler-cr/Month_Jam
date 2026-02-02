require("util")
require("graphics")
require("timer")
require("editorKeyHandler")


mouseX, mouseY = love.mouse.getPosition()

local   mouseCircleSize = {default = 7, click = 5}

function Editor.init()
    mouseSelected = nil

    Editor.stringCoord = Editor.coordsToString(0, 0)
    Editor.currentHoverIndex = -1
    Editor.currentHover = nil


    Editor.mouseOverSelectable = false
    Editor.inLevel = false

    clickTimer = Timer.simple(0) --init as timer so we don't have nil issues

    mouseCircleSize.current = 7


    Editor.levelFront = {}
    Editor.levelBack = {}
    Editor.curLevel = Editor.levelFront
    Editor.notCurLevel = Editor.levelBack

    selectables = {}

    local tile = 1
    local drawY = 48
    local drawX = 32

    for i = 1, 5 do
        for j = 1, 3 do
            if      tile == 12 then tile = 18
            elseif  tile == 22 then break end


            local new_block = Editor.blockInit(tile, drawX*(j)+20, drawY*(i)+64)
            table.insert(selectables, new_block)
            tile = tile + 1
        end
    end

    local new_block = Editor.blockInit(23, drawX*(1)+20, drawY*(6)+64)
    table.insert(selectables, new_block)
    local new_block = Editor.blockInit(26, drawX*(1)+20, drawY*(7)+64)
    table.insert(selectables, new_block)

end

function Editor.update(dt)
    Editor.currentHover = Editor.getCurrentHover()
    local xval = math.max((math.floor((mouseX)/24+.5))*24-8, Grid.leftwall)
    local yval = math.max((math.floor((mouseY)/24+.5))*24-12, Grid.ceiling)
    Editor.stringCoord = Editor.coordsToString(xval, yval)

    Editor.handleInput()
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


    --this needs to be implemented better. Find a way to put in editorKeyHandler
    if mouseX > 660 and mouseX < 788 and mouseY > 8 and mouseY < 72 then
        overSave = true
        if love.mouse.isDown(1) then Editor.saveLevel("test") end

    else overSave = false end


end

function Editor.draw()
    
    love.graphics.print(Editor.stringCoord)
    Editor.drawTileSquare()
    if mouseSelected then mouseSelected.draw() end

    love.graphics.rectangle("line", Grid.leftwall, Grid.ceiling, Grid.length+24, Grid.width+24)
    Editor.drawSelectTiles()
    Editor.drawLevelTiles()
    love.graphics.setColor(1,1,1)
    love.graphics.circle("fill", mouseX, mouseY, mouseCircleSize.current, mouseCircleSize.current)

    drawSave()

end

function Editor.drawLevelTiles()

    love.graphics.setColor(1,1,1,1)
    for _, block in pairs(Editor.curLevel) do
        block.draw()
    end
    love.graphics.setColor(.8,.9,.8,.4)
    for _, block in pairs(Editor.notCurLevel) do
        block.draw()
    end
    love.graphics.setColor(1,1,1,1)

end

function Editor.drawSelectTiles()

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
    print(tile)
    local block = {
        x = xval,
        y = yval,
        tile_i = tile,
        rotation = 0,
        flipXval = 1,
        flipYval = 1
    }

    if tile == 23 or tile == 26 then
        block.draw = function() drawTileBH_Editor(block.tile_i, block.x, block.y, block.rotation, block.flipXval, block.flipYval) end
    else 
        block.draw = function() drawTile_Editor(block.tile_i, block.x, block.y, block.rotation, block.flipXval, block.flipYval) end 
    end
    
    
    block.collides  =   function() return AABB(mouseX, mouseX, mouseY, mouseY, block.x, block.x+Block.size, block.y, block.y+Block.size) end
    block.rotate    =   function(value) block.rotation = block.rotation + value*math.pi/180 end
    block.flipX     =   function() block.flipXval = block.flipXval*(-1) end
    block.flipY     =   function() block.flipYval = block.flipYval*(-1) end

    return block

end

function Editor.goOtherSide()
    if Editor.curLevel == Editor.levelFront then 
        Editor.curLevel = Editor.levelBack
        Editor.notCurLevel = Editor.levelFront
    else 
        Editor.curLevel = Editor.levelFront
        Editor.notCurLevel = Editor.levelBack

    end
end

function Editor.dropBlock()
    local xval = math.max((math.floor((mouseX)/24+.5))*24-8, Grid.leftwall)
    local yval = math.max((math.floor((mouseY)/24+.5))*24-12, Grid.ceiling) 
    
    if not Editor.inLevel then
        local r = mouseSelected.rotation
        local flipX = mouseSelected.flipXval
        local flipY = mouseSelected.flipYval
        local new_block = Editor.blockInit(mouseSelected.tile_i, xval, yval)
        new_block.rotation = r
        new_block.flipXval = flipX
        new_block.flipYval = flipY
        if Editor.curLevel[Editor.stringCoord] then 
            print("Block already placed at this location!")
            return
        
        else
            -- shouldn't this be using the front and back logic, or am I tripping?
            Editor.curLevel[Editor.stringCoord] = new_block
        end

        --table.insert(Editor.curLevel, new_block)
        clickTimer = Timer.simple(.05)
    else
        mouseSelected.x = xval
        mouseSelected.y = yval
    end
    
    
    mouseSelected = nil
    Editor.inLevel = false
end

function Editor.deleteSelectedBlock()
    if Editor.curLevel[Editor.stringCoord] then Editor.deleteBlock() end
    mouseSelected = nil
end

function Editor.selectBlock()
    if Editor.mouseOverSelectable then Editor.copyBlock()
    else 
        mouseSelected = Editor.currentHover
        Editor.inLevel = true 
    end
end

function Editor.saveLevel()
    --TODO: Grab rotation, flip, etc
    local exists = io.open("rooms.lua", "r")

    -- if (#Editor.curLevel + #Editor.notCurLevel == 0) then
    --     --Need to fix this to handle my silly stringCoord logic
    --     print("there are this many blocks ")
    --     print(#Editor.levelFront + #Editor.levelBack)
    --     print("No blocks inserted. Going back to main menu!")
    --     Statestack.pop()
    --     Statestack.push(Start)
    --     return
    
    -- else
        
    if exists == nil then
        print("this is broken. No Bueno!")
    else
        local file = io.open("rooms.lua", "a+")
        if file then
            levelString = "{"
            for key, val in pairs(Editor.curLevel) do
                levelString = levelString..string.format("['%s'] = %d, ", key, val.tile_i)
            end
            levelString = levelString.."}"

            file:write(string.format("rooms['%s']= %s\n", newLevel, levelString))
            file:close()
        end
        print("this should be saving")
        Statestack.pop()
        Statestack.push(Start)
    end

   --local file = io.
end

function Editor.create(tile_i)
    if mouseSelected then Editor.dropBlock() end
    local newBlock = Editor.blockInit(tile_i, mouseX, mouseY)
    mouseSelected = newBlock
end

function Editor.drawTileSquare()

    local xval = math.max((math.floor((mouseX)/Block.size+.5))*Block.size-8, Grid.leftwall)
    local yval = math.max((math.floor((mouseY)/Block.size+.5))*Block.size-12, Grid.ceiling)
    xval = math.Clamp(xval, Grid.leftwall, Grid.rightwall)
    yval = math.Clamp(yval, Grid.ceiling, Grid.floor)

    love.graphics.rectangle("line", xval, yval, 24, 24)
end

function Editor.getCurrentHover()


    for _, block in pairs(selectables) do
        if block.collides(mouseX, mouseY) then
            Editor.mouseOverSelectable = true 
            return block
        end
    end
    Editor.mouseOverSelectable = false
    local xval = math.max((math.floor((mouseX)/24+.5))*24-8, Grid.leftwall)
    local yval = math.max((math.floor((mouseY)/24+.5))*24-12, Grid.ceiling)

    local block = Editor.curLevel[Editor.coordString]

    for _, block in pairs(Editor.curLevel) do
        if block.collides(mouseX, mouseY) then 
            return block
        end
    end
    Editor.currentHoverIndex = -1
    return nil
end

function Editor.copyBlock()
    if Editor.curLevel[Editor.stringCoord] then
        Editor.create(Editor.curLevel[Editor.stringCoord].tile_i)
    end
end

function Editor.deleteBlock()
    if Editor.curLevel[Editor.stringCoord] then
        Editor.curLevel[Editor.stringCoord] = nil
        --Editor.currentHover = nil
    end
end

--TODO
function Editor.connectTeleporters(bool)
end
--TODO
function Editor.disconnectTeleporters(bool)
end

function Editor.coordsToString(x, y)
    return tostring(x).." : "..tostring(y)
end