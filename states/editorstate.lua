require("util")
require("graphics")

Editor = {}


local mouseX, mouseY = love.mouse.getPosition()

local   mouseCircleSize = {default = 7, click = 5}

function Editor.init()
    mouseCircleSize.current = 7
end

function Editor.update(dt)

    local mX = love.mouse.isDown(1)

    mouseX, mouseY = love.mouse.getPosition()


    if keyPressed("escape") then
        Statestack.pop()
        Statestack.push(Start)
    end

    if mX then mouseCircleSize.current = mouseCircleSize.click
    else mouseCircleSize.current = mouseCircleSize.default end

end

function Editor.draw()
    love.graphics.circle("fill", mouseX, mouseY, mouseCircleSize.current, mouseCircleSize.current)

    local drawY = 30
    local drawX = 30
    love.graphics.setColor(1,1,1)

    for i = 1, 15 do
        love.graphics.rectangle("fill", drawX*(i%4)+24, drawY, 24, 24)
    end
end