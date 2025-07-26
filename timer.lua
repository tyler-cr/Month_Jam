Timer = {}

function Timer.create(duration, startFunction, endFunction)
    startFunction()
    local startTime = os.clock()
    return function()
        if os.clock() - startTime >= duration then
            endFunction()
            return true
        end
        return false
    end
end

function Timer.addToTable(list, timer)
    table.insert(list, timer)
end

function Timer.timekeeper(timeTable)
    for i = #timeTable, 1, -1 do
        local timerRef = timeTable[i]
        if timerRef and timerRef() then
            table.remove(timeTable, i)
        end
    end
end