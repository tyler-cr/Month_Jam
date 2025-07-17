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

function Tile.playerCollides(tile)
    if Player.my_x < tile.my_x + Block.size and
        Player.my_x + Block.size > tile.my_x and
        Player.my_y < tile.my_y + Block.size and
        Player.my_y + Block.size > tile.my_y then
        return true
    end
    return false
end

function Tile.resolvePlayerOverlap(tile)
    local px1, py1 = Player.my_x, Player.my_y
    local px2, py2 = px1 + Block.size, py1 + Block.size
    local tx1, ty1 = tile.my_x, tile.my_y
    local tx2, ty2 = tx1 + Block.size, ty1 + Block.size

    local overlapX = math.min(px2, tx2) - math.max(px1, tx1)
    local overlapY = math.min(py2, ty2) - math.max(py1, ty1)

    if overlapX < overlapY then
        Player.my_dx = 0
        if px1 < tx1 then
            Player.my_x = tx1 - Block.size
        else
            Player.my_x = tx2
        end
    else
        Player.my_dy = 1
        if py1 < ty1 then
            Player.my_y = ty1 - Block.size
        else
            Player.my_y = ty2
        end
    end
end


Bouncer.hit_box = {
    offset = 2,
    width = 4
}

Blackhole.pull = 24 --how far away a player 

function Block.init(x, y)
    local new_block = {
        my_x = x,
        my_y = y,
        size = Block.size,
        solid = Block.solid,
        collision_box = {x = x, y = y, width = Block.size},
    }

    new_block.on_collide = function() end --still gotta implement this. TODO
    new_block.draw = function() drawTile(Block.tile, new_block) end

    return new_block
end

function Computer:init(x, y)
    local new_computer = Block:init(x, y)

    new_computer.on_collide = function() Statestack.push() end --still gotta implement this. TODO
    -- new_computer.draw = function() drawTile(self.tile, new_computer) end

    return new_computer
end

function Bouncer:init(x, y)
    local new_bouncer = Block:init(x, y)

    new_bouncer.hit_box.x = new_bouncer.collision_box.x + Bouncer.collision_box.offset
    new_bouncer.hit_box.width = Bouncer.collision_box.width

    new_bouncer.on_hit = function() end
    -- new_bouncer.draw = function() drawTile(self.tile, new_bouncer) end

    return new_bouncer
end

function OneWayDoor:init(x, y)
    local new_onewaydoor = Block:init(x, y)

    new_onewaydoor.on_collide = function() end --make it only able to be walked through when on a certain flip axis. TODO

    -- new_onewaydoor.draw = function() drawTile(self.tile, new_onewaydoor) end

    return new_onewaydoor
end

function DirectionalDoor:init(x, y)
    local new_directionaldoor = Block:init(x, y)

    new_directionaldoor.on_collide = function() end --door can only be walked through going a certain direction. TODO
    -- new_directionaldoor.draw = function() drawTile(self.tile, new_directionaldoor) end

    return new_directionaldoor
end

function Cannon:init(x,y)
    local new_cannon = Block:init(x, y)

    new_cannon.on_collide = function() end --make it so that player enters cannon. TODO
    new_cannon.on_action = function() end  --make it that if player is inside the cannon and presses a direction, the cannon faces that way and shoots player out. TODO

    -- new_cannon.draw = function() drawTile(self.tile, new_cannon) end

    return new_cannon
end

function Teleport:init(x,y)
    local new_teleporter = Block:init(x, y)

    new_teleporter.on_collide = function() end --when the player goes through, they end up in connected teleporter. TODO
    new_teleporter.connect = function() end    --gives one-way portal to go to when collided with. TODO

    -- new_teleporter.draw = function() end --specialcase... TODO

    return new_teleporter
end

function Spikes:init(x, y)
    local new_spikes = Bouncer:init(x, y)

    new_spikes.on_collide = function() end --when player collides, they will die and reset level TODO

    -- new_spikes.draw = function() drawTile(self.tile, new_spikes) end

    return new_spikes
end

function Blackhole:init(x, y)
    local new_blackhole = Block:init(x, y)

    new_blackhole.influence = function() end --when player is withing pull distance, will pull player towards hole TODO
    new_blackhole.on_collide = function() end --same as new_spikes TODO

    return new_blackhole
end

function Whitehole:init(x, y)
    local new_whitehole = Blackhole:init(x, y)

    new_whitehole.influence = function() end --the opposite of the blackhole. TODO
    new_whitehole.on_collide = function() end --don't need to do anything here, but want to overwrite on collide so player doesn't die TODO

    -- new_whitehole.draw = function() end --specialcase... TODO

    return new_whitehole
end

function Ice:init(x, y)
    local new_ice = Bouncer:init(x, y)

    new_ice.collision_box.width = Block.size-- need full width to be iced out TODO

    new_ice.on_collide = function() end --need to overwrite bouncer collision logic, but should have more or less same logic TODO

    -- new_ice.draw = function() drawTile(self.tile, new_ice) end

    return new_ice
end

function FallAways:init(x, y)
    local new_fallaway = Bouncer:init(x, y)

    new_fallaway.on_collide = function() end --once player sets foot on block, prime it for on_leave TODO
    new_fallaway.on_leave = function() end   --once player steps off block, block will fall away and be removed TODO

    -- new_fallaway.draw = function() drawTile(self.tile, new_fallaway) end

    return new_fallaway
end

function Accelerator:init(x, y)
    local new_accelerator = Ice:init(x, y)

    new_accelerator.on_collide = function() end --make player go zoom in a specific direction.TODO

    return new_accelerator
end

function Glass:init(x, y)
    local new_glass = Block:init(x, y)

    new_glass.on_collide = function() end --If player hits the block at a certain angle and delta, the glass will break TODO

    -- new_glass.draw = function() drawTile(self.tile, new_glass) end

    return new_glass
end

