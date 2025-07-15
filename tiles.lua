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

Block = {}
Computer = {}
Bouncer = {}
OneWayDoor = {}
DirectionalDoor = {}
Cannon = {}
Teleport = {}
Spikes = {}
Blackhole = {}
Whitehole = {}
Ice = {}
FallAways = {}
Accelerator = {}
Glass = {}

Block.on_collide = function() end
Block.size = 8

Bouncer.collision_box = {
    offset = 2,
    width = 4
}

Blackhole.pull = 24 --how far away a player 

function Block.init(x, y)
    local new_block = {
        my_x = x,
        my_y = y,
        size = Block.size,
        collision_box = {x = x, y = y, width = Block.size},
    }

    return new_block
end

function Computer.init(x, y)
    local new_computer = Block.init(x, y)

    new_computer.on_collide = function() Statestack.push() end --still gotta implement this. TODO

    return new_computer
end

function Bouncer.init(x, y)
    local new_bouncer = Block.init(x, y)

    new_bouncer.collision_box.x = new_bouncer.collision_box.x + Bouncer.collision_box.offset
    new_bouncer.collision_box.width = Bouncer.collision_box.width

    new_bouncer.on_collide = function() end --depending on which way bouncer is rotated, will flip respective delta for player. TODO

    return new_bouncer
end

function OneWayDoor.init(x, y)
    local new_onewaydoor = Block.init(x, y)

    new_onewaydoor.on_collide = function() end --make it only able to be walked through when on a certain flip axis. TODO

    return new_onewaydoor
end

function DirectionalDoor.init(x, y)
    local new_directionaldoor = Block.init(x, y)

    new_directionaldoor.on_collide = function() end --door can only be walked through going a certain direction. TODO

    return new_directionaldoor
end

function Cannon.init(x,y)
    local new_cannon = Block.init(x, y)

    new_cannon.on_collide = function() end --make it so that player enters cannon. TODO
    new_cannon.on_action = function() end  --make it that if player is inside the cannon and presses a direction, the cannon faces that way and shoots player out. TODO

    return new_cannon
end

function Teleport.init(x,y)
    local new_teleporter = Block.init(x, y)

    new_teleporter.on_collide = function() end --when the player goes through, they end up in connected teleporter. TODO
    new_teleporter.connect = function() end    --gives one-way portal to go to when collided with. TODO

    return new_teleporter
end

function Spikes.init(x, y)
    local new_spikes = Bouncer.init(x, y)

    new_spikes.on_collide = function() end --when player collides, they will die and reset level TODO

    return new_spikes
end

function Blackhole.init(x, y)
    local new_blackhole = Block.init(x, y)

    new_blackhole.influence = function() end --when player is withing pull distance, will pull player towards hole TODO
    new_blackhole.on_collide = function() end --same as new_spikes TODO

    return new_blackhole
end

function Whitehole.init(x, y)
    local new_whitehole = Blackhole.init(x, y)

    new_whitehole.influence = function() end --the opposite of the blackhole. TODO
    new_whitehole.on_collide = function() end --don't need to do anything here, but want to overwrite on collide so player doesn't die TODO

    return new_whitehole
end

function Ice.init(x, y)
    local new_ice = Bouncer.init(x, y)

    new_ice.collision_box.width = Block.size-- need full width to be iced out TODO

    new_ice.on_collide = function() end --need to overwrite bouncer collision logic, but should have more or less same logic TODO

    return new_ice
end

function FallAways.init(x, y)
    local new_fallaway = Bouncer.init(x, y)

    new_fallaway.on_collide = function() end --once player sets foot on block, prime it for on_leave TODO
    new_fallaway.on_leave = function() end   --once player steps off block, block will fall away and be removed TODO

    return new_fallaway
end

function Accelerator.init(x, y)
    local new_accelerator = Ice.init(x, y)

    new_accelerator.on_collide = function() end --make player go zoom in a specific direction.TODO

    return new_accelerator
end

function Glass.init(x, y)
    local new_glass = Block.init(x, y)

    new_glass.on_collide = function() end --If player hits the block at a certain angle and delta, the glass will break TODO

    return new_glass
end

