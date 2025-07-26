require("timer")

CannonState = {cannon =  nil}

function CannonState.init()
    
    print("HISS")
    Player.drawMe = false

    impulse = {x = 1, y = 1}

    radians = 0

    timers = {}

    test = Timer.create(1, function ()
        print("start")
    end, function ()
        print("finish")
    end)

    Timer.addToTable(timers, test)
end

function CannonState.update(dt)

    Timer.timekeeper(timers)

    radians = -1 * CannonState.cannon.my_r
    CannonState.updateImpulse()

    if love.keyboard.isDown("left") then 
        CannonState.cannon.my_r = CannonState.cannon.my_r - dt
    end

    if love.keyboard.isDown("right") then 
        CannonState.cannon.my_r = CannonState.cannon.my_r + dt
    end

    if keyPressed("x") then 
        CannonState.shoot()
    end
end

function CannonState.shoot()
    Player.body:applyLinearImpulse(impulse.x*Cannon.shoot,impulse.y*Cannon.shoot)
    Statestack.pop()
    Player.drawMe = true
end

function CannonState.afterShoot()

end

function CannonState.updateImpulse()
    if radians > math.pi/2 and radians < 3*math.pi / 2 or radians < -math.pi/2 and radians > -3 * math.pi / 2 then impulse.x = -1
    else impulse.x = 1 end

    if math.abs(radians) >= 2 * math.pi then CannonState.cannon.my_r = 0 end

    impulse.y = -math.tan(radians) / impulse.x

end

function CannonState.draw()
    love.graphics.print(radians, 500, 0)
    love.graphics.print(impulse.x .." : "..impulse.y, 500, 20)
end


