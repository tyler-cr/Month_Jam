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
Cannon = {tile = tileset.tile.cannon, shoot = 500}
Spikes = {tile = tileset.tile.spikes}
Ice = {tile = tileset.tile.ice, friction = 0}
FallAways = {tile = tileset.tile.fallaways}
Accelerator = {tile = tileset.tile.accelerator}
Glass = {tile = tileset.tile.glass}

Blackhole = {tile = tileset.tile.blackhole}
Whitehole = {tile = tileset.tile.whitehole}
Teleport = {tile = tileset.tile.teleport}

Block.size = 24
Block.starting_rotation = 0

-- class wide functions
Tile = {}


function Tile.setrelative(self)
    self.relative_x =  self.my_x - Grid.center.x
    self.relative_y =  self.my_y - Grid.center.y
end

function Tile.setcoordfromrelative(self)
    self.my_x = self.relative_x + Grid.center.x
    self.my_y = self.relative_y + Grid.center.y
end

function Tile.rotate90(self)

    Tile.setrelative(self)

    local old_relative_x = self.relative_x
    local old_relative_y = self.relative_y

    self.relative_x = old_relative_y
    self.relative_y = -old_relative_x

    Tile.setcoordfromrelative(self)
    Physics.setPosn(self)

    self.my_r = self.my_r - math.pi/2

end

function Tile.rotateneg90(self)

    Tile.setrelative(self)

    local old_relative_x = self.relative_x
    local old_relative_y = self.relative_y

    self.relative_x = -old_relative_y
    self.relative_y = old_relative_x

    Tile.setcoordfromrelative(self)
    Physics.setPosn(self)

    self.my_r = self.my_r + math.pi/2

end

function Tile.flipXaxis(self)

    Tile.setrelative(self)

    self.relative_y = -self.relative_y
    Tile.setcoordfromrelative(self)
    Physics.flipXaxis(self)
    Physics.setPosn(self)

    self.my_r = -self.my_r

end

function Tile.flipYaxis(self)
    Tile.setrelative(self)

    self.relative_x = -self.relative_x
    Tile.setcoordfromrelative(self)
    Physics.flipYaxis(self)
    Physics.setPosn(self)

    self.my_r = math.pi - self.my_r

end

function Tile.handleRotAxis(self)
    if      keyPressed("q") then Tile.rotate90(self)
    elseif  keyPressed("e") then Tile.rotateneg90(self)
    elseif  keyPressed("w") or keyPressed("s") then Tile.flipXaxis(self)
    elseif  keyPressed("a") or keyPressed("d") then Tile.flipYaxis(self) end
end

Blackhole.pull = 64 --how far away a player
Blackhole.kill = 12

Whitehole.force = 3

function Block.init(x, y)
    local new_block = {
        drawMe = true,
        my_x = x,
        my_y = y,
        my_r = Block.starting_rotation,
        size = Block.size,
        collision_box = {x = x, y = y, width = Block.size},
    }

    new_block.collided = false

    new_block.name = "Block"
    Physics.createRectangle(new_block)
    new_block.fixture:setUserData(new_block)

    new_block.update = function(dt)
        if new_block.body:isDestroyed() then new_block.drawMe = false end

        Tile.handleRotAxis(new_block)
    end

    new_block.draw = function() drawTile(Block.tile, new_block, new_block.my_r) end

    return new_block
end

function Computer.init(x, y)
    local new_computer = Block.init(x, y)

    new_computer.name = "Computer"
    new_computer.fixture:setUserData(new_computer)

    new_computer.draw = function() drawTile(Computer.tile, new_computer, new_computer.my_r) end

    return new_computer
end

function Bouncer.init(x, y)
    local new_bouncer = Block.init(x, y)

    new_bouncer.name = "Bouncer"

    new_bouncer.fixture:setUserData(new_bouncer)

    new_bouncer.draw = function() drawTile(Bouncer.tile, new_bouncer, new_bouncer.my_r) end

    return new_bouncer
end

function OneWayDoor.init(x, y)
    local new_onewaydoor = Block.init(x, y)

    new_onewaydoor.name = "OneWayDoor"

    new_onewaydoor.fixture:setUserData(new_onewaydoor)

    new_onewaydoor.draw = function() drawTile(OneWayDoor.tile, new_onewaydoor, new_onewaydoor.my_r) end

    return new_onewaydoor
end

function DirectionalDoor.init(x, y)
    local new_directionaldoor = Block.init(x, y)

    new_directionaldoor.name = "DirectionalDoor"

    new_directionaldoor.fixture:setUserData(new_directionaldoor)

    new_directionaldoor.draw = function() drawTile(DirectionalDoor.tile, new_directionaldoor, new_directionaldoor.my_r) end

    return new_directionaldoor
end

function Cannon.init(x,y)
    local new_cannon = Block.init(x, y)
    new_cannon.my_r = Block.starting_rotation
    new_cannon.name = "Cannon"

    new_cannon.update = function(dt) 
        if new_cannon.fixture.hit == true then
            Statestack.push(CannonState(new_cannon))
        end

        Tile.handleRotAxis(new_cannon)

    end

    new_cannon.fixture:setUserData(new_cannon)
    new_cannon.draw = function() drawTile(Cannon.tile, new_cannon, new_cannon.my_r) end

    return new_cannon
end

function Teleport.init(x,y)
    local new_teleporter = Block.init(x, y)

    new_teleporter.name = "Teleport"
    new_teleporter.connectedTo = nil

    new_teleporter.fixture:setUserData(new_teleporter)
    new_teleporter.draw = function () drawTile(Teleport.tile[1], new_teleporter, new_teleporter.my_r) end
    new_teleporter.connect = function(other_teleport) 
        new_teleporter.connectedTo = other_teleport
        if other_teleport.connectedTo == nil then other_teleport.connectedTo = new_teleporter end
    end    --gives one-way portal to go to when collided with. TODO

    return new_teleporter
end

function Spikes.init(x, y)
    local new_spikes = Bouncer.init(x, y)

    new_spikes.name = "Spikes"

    new_spikes.fixture:setUserData(new_spikes)

    new_spikes.draw = function() drawTile(Spikes.tile, new_spikes, new_spikes.my_r) end

    return new_spikes
end

function Blackhole.init(x, y)
    local new_blackhole = Block.init(x, y)

    new_blackhole.center = {}

    new_blackhole.center.x = new_blackhole.my_x+12
    new_blackhole.center.y = new_blackhole.my_y+12

    new_blackhole.name = "Blackhole"

    new_blackhole.fixture:setUserData(new_blackhole)

    new_blackhole.update = function(dt)

        new_blackhole.center.x = new_blackhole.my_x+12
        new_blackhole.center.y = new_blackhole.my_y+12

        local distance = math.sqrt((Player.my_x - new_blackhole.center.x)^2+(Player.my_y - new_blackhole.center.y)^2)

        if distance <= Blackhole.pull then Player.body:applyLinearImpulse((new_blackhole.center.x - Player.my_x), (new_blackhole.center.y - Player.my_y)) end
        if distance <= Blackhole.kill then Player.die() end

        Tile.handleRotAxis(new_blackhole)
    end

    new_blackhole.draw = function()
        drawBH(Blackhole.tile, new_blackhole, new_blackhole.my_r)
        end

    return new_blackhole
end

function Whitehole.init(x, y)
    local new_whitehole = Blackhole.init(x, y)

    new_whitehole.name = "Whitehole"

    new_whitehole.fixture:setUserData(new_whitehole)

    new_whitehole.update = function(dt)

        new_whitehole.center.x = new_whitehole.my_x+12
        new_whitehole.center.y = new_whitehole.my_y+12

        local distance = math.sqrt((Player.my_x - new_whitehole.center.x)^2+(Player.my_y - new_whitehole.center.y)^2)

        if distance <= Blackhole.pull then Player.body:applyLinearImpulse(Whitehole.force*(Player.my_x - new_whitehole.center.x), Whitehole.force*(Player.my_y - new_whitehole.center.y)) end
  
        Tile.handleRotAxis(new_whitehole)
    end

    new_whitehole.draw = function() drawBH(Whitehole.tile, new_whitehole, new_whitehole.my_r) end

    return new_whitehole
end

function Ice.init(x, y)
    local new_ice = Bouncer.init(x, y)

    new_ice.name = "Ice"

    new_ice.fixture:setUserData(new_ice)
    new_ice.fixture:setFriction(Ice.friction)

    new_ice.draw = function() drawTile(Ice.tile, new_ice, new_ice.my_r) end
    return new_ice
end

function FallAways.init(x, y)
    local new_fallaway = Bouncer.init(x, y)

    new_fallaway.name = "FallAways"

    new_fallaway.fixture:setUserData(new_fallaway)
    new_fallaway.draw = function() drawTile(FallAways.tile, new_fallaway, new_fallaway) end

    return new_fallaway
end

function Accelerator.init(x, y)
    local new_accelerator = Ice.init(x, y)

    new_accelerator.name = "Accelerator"

    new_accelerator.fixture:setUserData(new_accelerator)
    new_accelerator.draw = function() drawTile(Accelerator.tile, new_accelerator, new_accelerator.my_r) end

    return new_accelerator
end

function Glass.init(x, y)
    local new_glass = Block.init(x, y)

    new_glass.name = "Glass"

    new_glass.fixture:setUserData(new_glass)
    new_glass.draw = function()
        drawTile(Glass.tile, new_glass, new_glass.my_r) end

    return new_glass
end