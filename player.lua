function math.Clamp(val, lower, upper)
    assert(val and lower and upper, "not very useful error message here")
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end

Player = {
    my_y = 100,
    my_x = 200,
    my_dy = 350,
    my_dx = 0,

    touching_left_wall = function () return Player.my_x <= 5   end,
    touching_right_wall= function () return Player.my_x >= 785 end,

    can_jump = function ()  return (Player.my_y >= 585 or Player.touching_left_wall() or Player.touching_right_wall()) end
}

function Player.update(dt)
    Player.handlemovement(dt)
end

function Player.handlejump()
    Player.my_dy = -350
    if Player.touching_left_wall() then 
        Player.my_dx = 500
    elseif Player.touching_right_wall() then
        Player.my_dx = -500
    end
end

function Player.handlemovement(dt)

    if (love.keyboard.isDown('up') and Player.can_jump()) then 
        print("your message here")
        Player.handlejump() end
        -- Player.my_y = math.max(Player.my_y - (300*dt), 5)
        -- Player.my_dy = 200
        -- Player.my_jump = false
     

    if love.keyboard.isDown('down') then Player.my_dy  = math.Clamp((Player.my_dy + 10)*dt, -400, 400) end
    
    if love.keyboard.isDown('left') then
        Player.my_dx  = math.Clamp((Player.my_dx - 50), -500, 500)
    elseif love.keyboard.isDown('right') then 
        Player.my_dx  = math.Clamp((Player.my_dx + 50), -500, 500)
    else
        if   math.abs(Player.my_dx) <= 25 then  Player.my_dx = 0
        else Player.my_dx = Player.my_dx * .90 end
        
    end

    --gravity
    if Player.my_y > 4 then Player.my_dy = Player.my_dy + 10
    elseif Player.my_y <= 4 then Player.my_dy = 0 end

    Player.my_y = math.Clamp(Player.my_y + Player.my_dy*dt, 4, 585)
    Player.my_x = math.Clamp(Player.my_x + Player.my_dx*dt, 5, 785)

end

function Player.resetlocation()
    Player.my_y = 100
    Player.my_x = 200
    Player.my_dy = 350
    Player.my_dx = 0
end