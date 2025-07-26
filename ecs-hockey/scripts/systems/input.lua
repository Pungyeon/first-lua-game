InputSystem = {}

local function handle_entity(key, entity)
    entity.velocity = Vector:new(0, 0)
    if love.keyboard.isDown("w") then
        entity.velocity.y = -1
    end
    if love.keyboard.isDown("s") then
        entity.velocity.y = 1
    end
    if love.keyboard.isDown("a") then
        entity.velocity.x = -1
    end
    if love.keyboard.isDown("d") then
        entity.velocity.x = 1
    end
end

function InputSystem:handle(key, entities)
    for i = 1, #entities do
        local entity = entities[i]
        if entity.selected and entity.velocity then
            handle_entity(key, entity)
        end
    end
end

return InputSystem
