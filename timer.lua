Timer = {}

Timer.table = {}

function Timer.create(duration, startFunction, endFunction)
    startFunction()
    local startTime = os.clock()

    Timer.addToTable(function()
        if os.clock() - startTime >= duration then
            endFunction()
            return true
        end
        return false
    end)
end

function Timer.addToTable(timer)
    table.insert(Timer.table, timer)
end

function Timer.timekeeper()
    for i = #Timer.table, 1, -1 do
        local timerRef = Timer.table[i]
        if timerRef and timerRef() then
            table.remove(Timer.table, i)
        end
    end
end