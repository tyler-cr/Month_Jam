require("graphics")

function deep_copy(orig)
    local copy = {}
    for k, v in pairs(orig) do
        if type(v) == "table" then
            copy[k] = deep_copy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

Block = {tile = tileset.tile.block}
Computer = {tile = tileset.tile.computer}
Bouncer = {tile = tileset.tile.bouncer}
OneWayDoor = {tile = tileset.tile.onewaydoor}
DirectionalDoor = {tile = tileset.tile.directionaldoor}
Cannon = {tile = tileset.tile.cannon}
Spikes = {tile = tileset.tile.spikes}
Ice = {tile = tileset.tile.ice}
FallAways = {tile = tileset.tile.fallaways}
Accelerator = {tile = tileset.tile.accelerator}
Glass = {tile = tileset.tile.glass}

Blackhole = {tile = tileset.tile.blackhole}
Whitehole = {tile = tileset.tile.whitehole}
Teleport = {tile = tileset.tile.teleport}

Block.on_collide = function() end
Block.size = 24
Block.solid = true

-- class wide functions
Tile = {}

Bouncer.hit_box = {
    offset = 2,
    width = 4
}

Blackhole.pull = 48 --how far away a player
Blackhole.kill = 12

function Block.init(x, y)
    local new_block = {
        drawMe = true,
        my_x = x,
        my_y = y,
        size = Block.size,
        solid = Block.solid,
        collision_box = {x = x, y = y, width = Block.size},
    }

    Physics.createRectangle(new_block)
    new_block.fixture:setUserData("Block")

    new_block.update = function(dt) if new_block.body:isDestroyed() then new_block.drawMe = false end end

    new_block.draw = function() drawTile(Block.tile, new_block) end

    return new_block
end

function Computer.init(x, y)
    local new_computer = Block.init(x, y)

    new_computer.fixture:setUserData("Computer")

    new_computer.draw = function() drawTile(Computer.tile, new_computer) end

    return new_computer
end

function Bouncer.init(x, y)
    local new_bouncer = Block.init(x, y)

    new_bouncer.fixture:setUserData("Bouncer")

    new_bouncer.draw = function() drawTile(Bouncer.tile, new_bouncer) end

    return new_bouncer
end

function OneWayDoor.init(x, y)
    local new_onewaydoor = Block.init(x, y)

    new_onewaydoor.fixture:setUserData("OneWayDoor")

    new_onewaydoor.draw = function() drawTile(OneWayDoor.tile, new_onewaydoor) end

    return new_onewaydoor
end

function DirectionalDoor.init(x, y)
    local new_directionaldoor = Block.init(x, y)

    new_directionaldoor.fixture:setUserData("DirectionalDoor")

    new_directionaldoor.draw = function() drawTile(DirectionalDoor.tile, new_directionaldoor) end

    return new_directionaldoor
end

function Cannon.init(x,y)
    local new_cannon = Block.init(x, y)

    new_cannon.fixture:setUserData("Cannon")
    new_cannon.draw = function() drawTile(Cannon.tile, new_cannon) end

    return new_cannon
end

function Teleport.init(x,y)
    local new_teleporter = Block.init(x, y)

    new_teleporter.fixture:setUserData("Teleport")
    new_teleporter.draw = function () drawTile(Teleport.tile[1], new_teleporter) end
    new_teleporter.connect = function() end    --gives one-way portal to go to when collided with. TODO

    return new_teleporter
end

function Spikes.init(x, y)
    local new_spikes = Bouncer.init(x, y)

    new_spikes.fixture:setUserData("Spikes")

    new_spikes.draw = function() drawTile(Spikes.tile, new_spikes) end

    return new_spikes
end

function Blackhole.init(x, y)
    local new_blackhole = Block.init(x, y)

    new_blackhole.center = {}

    new_blackhole.center.x = new_blackhole.my_x+12
    new_blackhole.center.y = new_blackhole.my_y+12


    new_blackhole.fixture:setUserData("Blackhole")

    new_blackhole.update = function(dt)
        local distance = math.sqrt((Player.my_x - new_blackhole.center.x)^2+(Player.my_y - new_blackhole.center.y)^2)
   
        if distance <= 64 then Player.body:applyLinearImpulse((new_blackhole.center.x - Player.my_x), (new_blackhole.center.y - Player.my_y)) end
        if distance <= 24 then Player.die() end
    end

    new_blackhole.draw = function() drawBH(Blackhole.tile, new_blackhole) end

    return new_blackhole
end

function Whitehole.init(x, y)
    local new_whitehole = Blackhole.init(x, y)

    new_whitehole.fixture:setUserData("Whitehole")

    new_whitehole.update = function(dt)
        local distance = math.sqrt((Player.my_x+12 - new_whitehole.center.x)^2+(Player.my_y+12 - new_whitehole.center.y)^2)
   
        if distance <= Blackhole.pull then Player.body:applyLinearImpulse((Player.my_x - new_whitehole.center.x), (Player.my_y - new_whitehole.center.y)) end
        if distance <= Blackhole.kill then Player.die() end
    end

    new_whitehole.draw = function() drawBH(Whitehole.tile, new_whitehole) end

    return new_whitehole
end

function Ice.init(x, y)
    local new_ice = Bouncer.init(x, y)

    new_ice.fixture:setUserData("Ice")
    new_ice.draw = function() drawTile(Ice.tile, new_ice) end

    return new_ice
end

function FallAways.init(x, y)
    local new_fallaway = Bouncer.init(x, y)

    new_fallaway.fixture:setUserData("FallAways")
    new_fallaway.draw = function() drawTile(FallAways.tile, new_fallaway) end

    return new_fallaway
end

function Accelerator.init(x, y)
    local new_accelerator = Ice.init(x, y)

    new_accelerator.fixture:setUserData("Accelerator")
    new_accelerator.draw = function() drawTile(Accelerator.tile, new_accelerator) end

    return new_accelerator
end

function Glass.init(x, y)
    local new_glass = Block.init(x, y)

    new_glass.fixture:setUserData("Glass")
    new_glass.draw = function() drawTile(Glass.tile, new_glass) end

    return new_glass
end

