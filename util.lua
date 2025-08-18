function AABB(obj1Left, obj1Right, obj1Top, obj1Bottom, obj2Left, obj2Right, obj2Top, obj2Bottom)
    return obj1Left < obj2Right and
           obj1Right > obj2Left and
           obj1Top < obj2Bottom and
           obj1Bottom > obj2Top
end