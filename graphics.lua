Tileset =       love.graphics.newImage('images/tileset.png')
StartButtons =  love.graphics.newImage('images/startbuttons1.png')

function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y=0, sheetHeight-1 do
        for x=0, sheetWidth-1 do
            spritesheet[sheetCounter]=
                love.graphics.newQuad(x*tilewidth+(2*x),y*tileheight+(2*y), tilewidth,
                    tileheight, atlas:getDimensions())
                sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

local quadtable =  GenerateQuads(Tileset,       24, 24)
local startQuad =  GenerateQuads(StartButtons,  128, 64)

startButton1 = startQuad[1]
startButton2 = startQuad[2]

tileset = {tile = {}, rotation = {}, scale = {}}
tileset.tile.block =             quadtable[1]
tileset.tile.computer =          quadtable[2]
tileset.tile.bouncer =           quadtable[3]
tileset.tile.onewaydoor =        quadtable[5]
tileset.tile.directionaldoor =   quadtable[4]
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

tileset.rotation.default = 0


function drawTile(tile, new_tile, r)

    if r == nil then r = tileset.rotation.default end

    love.graphics.draw(Tileset, tile, new_tile.my_x+12, new_tile.my_y+12, r, 1, 1, 12, 12)
end

function drawBH(type, new_tile)
    local middleX, middleY = new_tile.my_x, new_tile.my_y
    for i = 1, 3 do
        local drawtop = type.top[i]
        local drawmid = type.middle[i]

        love.graphics.draw(Tileset, drawtop, middleX+24*(-2 + i), middleY-Block.size, 0)
        love.graphics.draw(Tileset, drawmid, middleX+24*(-2 + i), middleY, 0)
    end
        love.graphics.draw(Tileset, type.bottom[1], middleX, middleY+Block.size, 0)
end