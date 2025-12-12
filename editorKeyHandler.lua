Editor = {}


-- I know this is datastructs, but having this here
-- makes sense for now
function Editor.getInputState()
    return {
        key   = Editor.grabKey(),
        m1    = love.mouse.isDown(1),
        m2    = love.mouse.isDown(2),
        shift = love.keyboard.isDown("lshift", "rshift"),
        alt   = love.keyboard.isDown("lalt", "ralt"),
        cmd   = love.keyboard.isDown("lgui", "rgui")
    }
end

function Editor.handleInput()
    local state = Editor.getInputState()
    local action = state.key or m1 or m2
    if not action then return end


    if state.shift then mod = "shift"
    elseif state.alt then mod = "alt"
    elseif state.cmd then mod = "cmd"
    else mod = "normal" end

    context = Editor.getContext()

    local func = Editor[context.."Actions"][mod][action]
    if func then func() end
end

function Editor.grabKey()
    for _, k in ipairs(getKeys()) do
        if k ~= "lshift" and k ~= "rshift" and k~= "lalt" and k~= "ralt" and k~= "lgui" and k~= "rgui" then 
            return Editor.shiftKeyEnum[k]
        end
    end
end

function Editor.getContext()
    if mouseSelected then return "block" 
    elseif Editor.getCurrentHover() then return "hover"
    else return "default" end
end

Editor.keyEnum = {
    ["1"] = 1,     -- block
    ["2"] = 2,     -- computer
    ["3"] = 3,     -- bouncer
    ["4"] = 4,     -- onewaydoor
    ["5"] = 5,     -- directionaldoor
    ["6"] = 6,     -- opendoor
    ["7"] = 7,     -- cannon
    ["8"] = 11,    -- spikes
    ["9"] = 18,    -- ice
    ["0"] = 19,    -- fallaways
    ["-"] = 20,    -- accelerator
    ["="] = 21    -- glass
}

Editor.shiftKeyEnum = {
    ["1"] = 23, -- blackhole
    ["2"] = 26, -- whitehole
    ["3"] = 8,  -- teleport1
    ["4"] = 9,  -- teleport2
    ["5"] = 10, -- teleport3
}

--map actions will likely go in here at some point
Editor.defaultActions = {
    normal = {
        ["1"] = function() Editor.create(Editor.keyEnum["1"]) end,
        ["2"] = function() Editor.create(Editor.keyEnum["2"]) end,
        ["3"] = function() Editor.create(Editor.keyEnum["3"]) end,
        ["4"] = function() Editor.create(Editor.keyEnum["4"]) end,
        ["5"] = function() Editor.create(Editor.keyEnum["5"]) end,
        ["6"] = function() Editor.create(Editor.keyEnum["6"]) end,
        ["7"] = function() Editor.create(Editor.keyEnum["7"]) end,
        ["8"] = function() Editor.create(Editor.keyEnum["8"]) end,
        ["9"] = function() Editor.create(Editor.keyEnum["9"]) end,
        ["0"] = function() Editor.create(Editor.keyEnum["0"]) end,
        ["-"] = function() Editor.create(Editor.keyEnum["-"]) end,
        ["="] = function() Editor.create(Editor.keyEnum["="]) end,
        ["left"]    =  function() love.mouse.setPosition(mouseX-Block.size, mouseY) end,
        ["right"]   = function() love.mouse.setPosition(mouseX+Block.size, mouseY) end,
        ["up"]      =    function() love.mouse.setPosition(mouseX, mouseY-Block.size) end,
        ["down"]    =  function() love.mouse.setPosition(mouseX, mouseY+Block.size) end
    },

    shift = {
        ["1"] = function() Editor.create(Editor.shiftKeyEnum["1"]) end,
        ["2"] = function() Editor.create(Editor.shiftKeyEnum["2"]) end,
        ["3"] = function() Editor.create(Editor.shiftKeyEnum["3"]) end,
        ["4"] = function() Editor.create(Editor.shiftKeyEnum["4"]) end,
        ["5"] = function() Editor.create(Editor.shiftKeyEnum["5"]) end,
        ["left"]    =  function() love.mouse.setPosition(mouseX-Block.size*3, mouseY) end,
        ["right"]   = function() love.mouse.setPosition(mouseX+Block.size*3, mouseY) end,
        ["up"]      =    function() love.mouse.setPosition(mouseX, mouseY-Block.size*3) end,
        ["down"]    =  function() love.mouse.setPosition(mouseX, mouseY+Block.size*3) end
    },

    alt = {
        ["left"]   =  function() love.mouse.setPosition(Grid.leftwall, mouseY) end,
        ["right"]   = function() love.mouse.setPosition(Grid.rightwall, mouseY) end,
        ["up"]      =    function() love.mouse.setPosition(mouseX, Grid.ceiling) end,
        ["down"]    =  function() love.mouse.setPosition(mouseX, Grid.floor) end
    }
}

Editor.blockActions = {
    normal = {
        ["e"] = function(b) b:rotate(90) end,
        ["q"] = function(b) b:rotate(-90) end,
        ["a"] = function(b) b:flipX() end,
        ["d"] = function(b) b:flipX() end,
        ["w"] = function(b) b:flipY() end,
        ["s"] = function(b) b:flipY() end,
        ["g"] = function() Editor.connectTeleporters(true) end, --not implimented yet
        ["h"] = function() Editor.connectTeleporters(false) end,--not implimented yet
        ["return"] = function() Editor.dropBlock() end,
        ["delete"] = function() Editor.deleteSelectedBlock() end
    },

    shift = {
        ["g"] = function() Editor.disconnectTeleporters(true) end,--not implimented
        ["h"] = function() Editor.disconnectTeleporters(false) end,--not implimented
    },

    mouse = {
        [1] = function() Editor.dropBlock() end,
        [2] = function() Editor.deleteSelectedBlock() end
    }
}

--TODO: more or less not implemented
Editor.mapActions = {
    normal = {
        ["x"] = function() Editor.goOtherSide() end,
    },

    shift = {
        ["r"] = function() Editor.setRules() end, --not implemented
        ["e"] = function() Editor.rotateMap(90) end, --not implemented
        ["q"] = function() Editor.rotateMap(-90) end, --not implemented
        ["a"] = function() Editor.flipMapX(false) end, --not implemented
        ["d"] = function() Editor.flipMapX(false) end, --not implemented
        ["w"] = function() Editor.flipMapY(false) end, --not implemented
        ["s"] = function() Editor.flipMapY(false) end, --not implemented
    },

    alt = {
        ["a"] = function() Editor.goOtherSideFlipX() end, --not implemented
        ["d"] = function() Editor.goOtherSideFlipX() end, --not implemented
        ["w"] = function() Editor.goOtherSideFlipY() end, --not implemented
        ["s"] = function() Editor.goOtherSideFlipY() end, --not implemented
    }
}

Editor.hoverActions = {
    normal = {
        ["c"] = function() Editor.copyBlock() end,
        ["v"] = function() Editor.deleteBlock() end,
        ["return"] = function() Editor.selectBlock() end
    },

    mouse = {
        [1] = function() Editor.selectBlock() end
    }
}


