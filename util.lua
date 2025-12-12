function AABB(obj1Left, obj1Right, obj1Top, obj1Bottom, obj2Left, obj2Right, obj2Top, obj2Bottom)
    return obj1Left < obj2Right and
           obj1Right > obj2Left and
           obj1Top < obj2Bottom and
           obj1Bottom > obj2Top
end

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

function math.Clamp(val, lower, upper)
    assert(val and lower and upper, "not very useful error message here")
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end