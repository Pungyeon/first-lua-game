Physics = {}
Physics.__index = Physics

function Physics:new()
    local obj = {}
    setmetatable(obj, self)
    return obj
end

function Physics:handle(dt, entities)
    for i = 1, #entities do
        local entity = entities[i]
        if entity.physics then
            entity.physics:handle(dt, entity)
        end
    end
end

return Physics
