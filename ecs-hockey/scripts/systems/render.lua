Render = {}
Render.__index = Render

function Render:new()
    local obj = {}
    setmetatable(obj, self)
    return obj
end

function Render:handle(entities)
    for i = 1, #entities do
        local entity = entities[i]
        if entity.draw then
            entity:draw()
        end
    end
end

return Render
