---@diagnostic disable: undefined-field
require("timer")

CannonState = {cannon =  nil}

function CannonState.init()

    --Player.drawMe = false

    --starter values
    impulse = {x = 0, y = 0}
    radians = 0

end

function CannonState.update(dt)

    -- my_r rotation is clockwise, but angles are handles counterclockwise
    radians = -CannonState.cannon.my_r

    CannonState.updateImpulse()
    CannonState.updatePlayer()

    if love.keyboard.isDown("left") then 
        CannonState.cannon.my_r = CannonState.cannon.my_r - dt
        Player.my_r = Player.my_r - dt
    end

    if love.keyboard.isDown("right") then 
        CannonState.cannon.my_r = CannonState.cannon.my_r + dt
        Player.my_r = Player.my_r + dt
    end

    if keyPressed("x") then
        CannonState.shoot()
    end
end

function CannonState.shoot()
    Player.body:applyLinearImpulse(impulse.x*Cannon.shoot, impulse.y*Cannon.shoot)
    Statestack.pop()
    Player.drawMe = true
end

function CannonState.updatePlayer()

    Player.my_x = CannonState.cannon.my_x + math.cos(radians)*Block.size
    Player.my_y = CannonState.cannon.my_y - math.sin(radians)*Block.size

    Physics.setPosn(Player)
end

function CannonState.updateImpulse()

    impulse.x = math.cos(radians)
    impulse.y = -math.sin(radians)

end

function CannonState.draw()
    love.graphics.print(math.floor(impulse.x).." : "..math.floor(impulse.y))
end


