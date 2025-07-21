Tileset = love.graphics.newImage('images/tileset.png')

function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y=0, sheetHeight-1 do
        for x=0, sheetWidth-1 do
            spritesheet[sheetCounter]=
                love.graphics.newQuad(x*tilewidth,y*tileheight, tilewidth,
                    tileheight, atlas:getDimensions())
                sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

--divide quads into subtables
function GenerateTileSets(quads, setsX, setsY, sizeX, sizeY)
    local tilesets = {}
    local tableCounter = 0
    local sheetWidth = setsX*sizeX
    local sheetHeight = setsY*sizeY

    for tilesetY = 1, setsY do
        for tilesetX = 1, setsX do
            
            -- tileset table
            table.insert(tilesets, {})
            tableCounter = tableCounter + 1

            for y = sizeY * (tilesetY - 1) + 1, sizeY * (tilesetY - 1) + 1 + sizeY do
                for x = sizeX * (tilesetX - 1) + 1, sizeX * (tilesetX - 1) + 1 + sizeX do
                    table.insert(tilesets[tableCounter], quads[sheetWidth * (y - 1) + x])
                end
            end
        end
    end

    return tilesets
end

local quadtable =  GenerateQuads(Tileset, 8, 8)

tileset = {tile = {}, rotation = {}, scale = {}}
tileset.tile.block =             quadtable[1]
tileset.tile.computer =          quadtable[2]
tileset.tile.bouncer =           quadtable[3]
tileset.tile.onewaydoor =        quadtable[4]
tileset.tile.directionaldoor =   quadtable[5]
tileset.tile.opendoor =          quadtable[6]
tileset.tile.cannon =            quadtable[7]
tileset.tile.teleport =       {quadtable[8], quadtable[9], quadtable[10]}

tileset.tile.spikes =            quadtable[11]
tileset.tile.ice =               quadtable[18]
tileset.tile.fallaways =         quadtable[19]
tileset.tile.accelerator =       quadtable[20]
tileset.tile.glass =             quadtable[21]

tileset.tile.player_active =     quadtable[28]
tileset.tile.player_win =        quadtable[29]
tileset.tile.player_death =      quadtable[30]

tileset.tile.blackhole = {top = {quadtable[12], quadtable[13], quadtable[14]}, middle = {quadtable[22], quadtable[23], quadtable[24]}, bottom = {quadtable[33]}}
tileset.tile.whitehole = {top = {quadtable[15], quadtable[16], quadtable[17]}, middle = {quadtable[25], quadtable[26], quadtable[27]}, bottom = {quadtable[36]}}

tileset.scale = 3
tileset.rotation.default = 0



function drawTile(tile, new_tile)

    if r == nil then r = tileset.rotation.default end

    love.graphics.draw(Tileset, tile, new_tile.my_x, new_tile.my_y, r, tileset.scale, tileset.scale)
end

function drawBH(type, new_tile)
    local middleX, middleY = new_tile.my_x, new_tile.my_y
    for i = 1, 3 do
        local drawtop = type.top[i]
        local drawmid = type.middle[i]

        love.graphics.draw(Tileset, drawtop, middleX+24*(-2 + i), middleY-Block.size, 0, tileset.scale, tileset.scale)
        love.graphics.draw(Tileset, drawmid, middleX+24*(-2 + i), middleY, 0, tileset.scale, tileset.scale)
    end
        love.graphics.draw(Tileset, type.bottom[1], middleX, middleY+Block.size, 0, tileset.scale, tileset.scale)
end