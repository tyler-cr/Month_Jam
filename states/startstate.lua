require("util")

Start = {}

local mouseX, mouseY = love.mouse.getPosition()

local   mouseCircleSize = {default = 7, click = 5}

local   startButton = {left = 336, right = 464, top = 100, bottom = 164}
local   editorButton = {left = 336, right = 464, top = 400, bottom = 464}


function Start.init()
end

function Start.update(dt)

    if keyPressed("escape") then love.event.quit() end

    local mX = love.mouse.isDown(1)

    mouseX, mouseY = love.mouse.getPosition()

    if mX then mouseCircleSize.current = mouseCircleSize.click
    else mouseCircleSize.current = mouseCircleSize.default end

    if mX and AABB(mouseX, mouseX, mouseY, mouseY, startButton.left, startButton.right, startButton.top, startButton.bottom) then
        Statestack.pop()
        Statestack.push(Level)
    elseif mX and AABB(mouseX, mouseX, mouseY, mouseY, editorButton.left, editorButton.right, editorButton.top, editorButton.bottom) then
        Statestack.pop()
        Statestack.push(Editor)
    end

end

function Start.draw()

    love.graphics.draw(StartButtons, startButton1, 336, 100)

    love.graphics.draw(StartButtons, startButton2, 336, 400)

    love.graphics.circle("fill", mouseX, mouseY, mouseCircleSize.current, mouseCircleSize.current)
end