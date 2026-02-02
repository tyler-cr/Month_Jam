--TODO: make this work

local textbox = {
  x = 40, y = 40, w = 320, h = 32,
  text = "",
  active = false,
  caret = 0
}

function textbox:hit(mx, my)
  return mx >= self.x and mx <= self.x + self.w and my >= self.y and my <= self.y + self.h
end

function textbox:setActive(on)
  self.active = on
  if on then
    love.keyboard.setTextInput(true)
    self.caret = #self.text
  else
    love.keyboard.setTextInput(false)
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    textbox:setActive(textbox:hit(x, y))
  end
end

function love.textinput(t)
  if not textbox.active then return end
  textbox.text = textbox.text:sub(1, textbox.caret) .. t .. textbox.text:sub(textbox.caret + 1)
  textbox.caret = textbox.caret + #t
end

function love.keypressed(key)
  if not textbox.active then return end

  if key == "backspace" then
    if textbox.caret > 0 then
      textbox.text = textbox.text:sub(1, textbox.caret - 1) .. textbox.text:sub(textbox.caret + 1)
      textbox.caret = textbox.caret - 1
    end
  elseif key == "delete" then
    if textbox.caret < #textbox.text then
      textbox.text = textbox.text:sub(1, textbox.caret) .. textbox.text:sub(textbox.caret + 2)
    end
  elseif key == "left" then
    textbox.caret = math.max(0, textbox.caret - 1)
  elseif key == "right" then
    textbox.caret = math.min(#textbox.text, textbox.caret + 1)
  elseif key == "home" then
    textbox.caret = 0
  elseif key == "end" then
    textbox.caret = #textbox.text
  elseif key == "return" or key == "kpenter" then
    textbox:setActive(false)
  elseif key == "escape" then
    textbox:setActive(false)
  end
end

function love.draw()
  love.graphics.rectangle("line", textbox.x, textbox.y, textbox.w, textbox.h)
  love.graphics.print(textbox.text, textbox.x + 6, textbox.y + 6)

  if textbox.active then
    local before = textbox.text:sub(1, textbox.caret)
    local cx = textbox.x + 6 + love.graphics.getFont():getWidth(before)
    local cy1 = textbox.y + 6
    local cy2 = textbox.y + textbox.h - 6
    if math.floor(love.timer.getTime() * 2) % 2 == 0 then
      love.graphics.line(cx, cy1, cx, cy2)
    end
  end
end
