statestack = {}

-- for functions
Statestack = {}

function Statestack.push(state)
    table.insert(statestack, 1, state)
end

function Statestack.pop()
    table.remove(statestack, 1)
end

function Statestack.empty()
    statestack = {}
end

function Statestack.update(dt)
    if statestack[1] then statestack[1].update(dt) end
end

function Statestack.render()
    for i = #statestack, 1, -1 do
        statestack[i].render()
    end
end