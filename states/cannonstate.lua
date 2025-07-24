CannonState = {}

function CannonState.init(Cannon)
    CannonState.cannon = Cannon
    print("HISS")
    Player.drawMe = false
end

function CannonState.update(dt)
    if keyPressed("left") then 
        CannonState.cannon.my_r = CannonState.cannon.my_r - 5
    end

    if keyPressed("right") then 
        CannonState.cannon.my_r = CannonState.cannon.my_r + 5
    end

    if keyPressed("x") then 
        print("BOOM!!!")
        Statestack.pop() 
        Player.drawMe = true
        end
end

function CannonState.draw()
end