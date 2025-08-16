function readMap(imagePath)

    local newMap = {}

    local imagedata = love.image.newImageData(imagePath)
    for x = 1, imagedata:getWidth()-1 do
        for y = 1, imagedata:getHeight()-1 do
            local r, g, b = imagedata:getPixel(x, y)
            table.insert(newMap, {xVal = x*Block.size, yVal = y*Block.size, red = r, green = g, blue = b})
        end
    end

    return newMap
end

function compColorTables(blockData)
    for _, colorBlock in pairs(Map.tiles) do
        if colorBlock[2] == blockData.red and colorBlock[3] == blockData.green and colorBlock[4] == blockData.blue then
            return colorBlock[1]
        end
    end
end

function switchBlockInit(block)
        if block.type == "Player" then
            return Player.init(block.xVal, block.yVal)
    elseif block.type == "Block" then
            return Block.init(block.xVal, block.yVal)
    elseif block.type == "Computer" then
            return Computer.init(block.xVal, block.yVal)
    elseif block.type == "Bouncer" then
            return Bouncer.init(block.xVal, block.yVal)
    elseif block.type == "OneWayDoor" then
            return OneWayDoor.init(block.xVal, block.yVal)
    elseif block.type == "DirectionalDoor" then
            return DirectionalDoor.init(block.xVal, block.yVal)
    elseif block.type == "Cannon" then
            return Cannon.init(block.xVal, block.yVal)
    elseif block.type == "Spikes" then
            return Spikes.init(block.xVal, block.yVal)
    elseif block.type == "Ice" then
            return Ice.init(block.xVal, block.yVal)
    elseif block.type == "FallAways" then
            return FallAways.init(block.xVal, block.yVal)
    elseif block.type == "Accelerator" then
            return Accelerator.init(block.xVal, block.yVal)
    elseif block.type == "Glass" then
            return Glass.init(block.xVal, block.yVal)
    elseif block.type == "Blackhole" then
            return Blackhole.init(block.xVal, block.yVal)
    elseif block.type == "Whitehole" then
            return Whitehole.init(block.xVal, block.yVal)
    elseif block.type == "Teleport" then
            return Teleport.init(block.xVal, block.yVal)
    end
end


Map = {}

Map.tiles = {
    Player          = {"Player", 255, 0, 231},
    Block           = {"Block", 66, 57, 255},
    Computer        = {"Computer", 255, 252, 64},
    Bouncer         = {"Bouncer", 250, 106, 10},
    OneWayDoor      = {"OneWayDoor", 180, 32, 42},
    DirectionalDoor = {"DirectionalDoor", 156, 219, 67},
    Cannon          = {"Cannon", 185, 191, 251},
    Spikes          = {"Spikes", 244, 210, 156},
    Ice             = {"Ice", 32, 214, 199},
    FallAways       = {"FallAways", 199, 176, 139},
    Accelerator     = {"Accelerator", 35, 103, 78},
    Glass           = {"Glass", 40,92,196},
    Blackhole       = {"Blackhole", 6, 6, 8},
    Whitehole       = {"Whitehole", 254, 254, 254},
    Teleport        = {"Teleport", 50, 132, 100},
}