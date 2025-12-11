MapMaker = {}

local Map = {}

Map.tiles = {
    Player          = {"Player",                255/255, 0/255,   231/255},
    Block           = {"Block",                 66/255,  57/255,  255/255},
    Computer        = {"Computer",              255/255, 252/255, 64/255},
    Bouncer         = {"Bouncer",               250/255, 106/255, 10/255},
    OneWayDoor      = {"OneWayDoor",            180/255, 32/255,  42/255},
    DirectionalDoor = {"DirectionalDoor",       156/255, 219/255, 67/255},
    Cannon          = {"Cannon",                185/255, 191/255, 251/255},
    Spikes          = {"Spikes",                244/255, 210/255, 156/255},
    Ice             = {"Ice",                   32/255,  214/255, 199/255},
    FallAways       = {"FallAways",             199/255, 176/255, 139/255},
    Accelerator     = {"Accelerator",           35/255,  103/255, 78/255},
    Glass           = {"Glass",                 40/255,  92/255,  196/255},
    Blackhole       = {"Blackhole",             6/255,   6/255,   8/255},
    Whitehole       = {"Whitehole",             254/255, 254/255, 254/255},
    Teleport        = {"Teleport",              50/255,  132/255, 100/255},
}

function MapMaker.generateTableFromPath(imagePath)
    local blockData  = MapMaker.generateBlockData(imagePath)
    local blockTable = MapMaker.generateBlockTable(blockData)
    return blockTable
end

function MapMaker.generateBlockData(imagePath)
    local newMap = {}
    local imagedata = love.image.newImageData(imagePath)

    for x = 0, imagedata:getWidth()-1 do
        for y = 0, imagedata:getHeight()-1 do
            local r, g, b = imagedata:getPixel(x, y)
            if r + g + b ~= 0 then
                table.insert(newMap, {
                    xVal = x * Block.size,
                    yVal = y * Block.size,
                    red  = r, green = g, blue = b
                })
            end
        end
    end
    return newMap
end

-- build color lookup table once
local colorLookup = {}
for _, def in pairs(Map.tiles) do
    local key = string.format("%.3f,%.3f,%.3f", def[2], def[3], def[4])
    colorLookup[key] = def[1]
end

-- block init functions mapped by type
local initLookup = {
    Player          = function(x,y) return end,
    Block           = function(x,y) print("Block incoming!"); return Block.init(x,y) end,
    Computer        = function(x,y) return Computer.init(x,y) end,
    Bouncer         = function(x,y) return Bouncer.init(x,y) end,
    OneWayDoor      = function(x,y) return OneWayDoor.init(x,y) end,
    DirectionalDoor = function(x,y) return DirectionalDoor.init(x,y) end,
    Cannon          = function(x,y) return Cannon.init(x,y) end,
    Spikes          = function(x,y) return Spikes.init(x,y) end,
    Ice             = function(x,y) return Ice.init(x,y) end,
    FallAways       = function(x,y) return FallAways.init(x,y) end,
    Accelerator     = function(x,y) return Accelerator.init(x,y) end,
    Glass           = function(x,y) return Glass.init(x,y) end,
    Blackhole       = function(x,y) return Blackhole.init(x,y) end,
    Whitehole       = function(x,y) return Whitehole.init(x,y) end,
    Teleport        = function(x,y) return Teleport.init(x,y) end,
}

function MapMaker.generateBlockTable(blockData)
    local retTable = {}
    for _, data in ipairs(blockData) do
        local key = string.format("%.3f,%.3f,%.3f", data.red, data.green, data.blue)
        local typeName = colorLookup[key]
        if typeName then
            local initFunc = initLookup[typeName]
            if initFunc then
                local obj = initFunc(data.xVal, data.yVal)
                if obj then table.insert(retTable, obj) end
            end
        end
    end
    return retTable
end