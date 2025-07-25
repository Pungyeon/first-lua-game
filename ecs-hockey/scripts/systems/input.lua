Input = {}
Input.__index = Input

function Input:new()
    local obj = {}
    setmetatable(obj, self)
    return obj
end

function Input:handle(entities)
    for i = 1, #entities do
        local entity = entities[i]
        if entity.input then
            entity.input:handle(entity)
        end
    end
end

return Input
