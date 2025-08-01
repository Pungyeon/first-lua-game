local EventBus = require("scripts/types/event_bus")

InputSystem = {
    l_down = false,
    k_down = false,
    n_down = false
}

local function handle_entity(key, entity)
    if entity.collision.bounce > 0 then
        entity.collision.bounce = entity.collision.bounce - 1
        return
    end
    entity.velocity = Vector:new(0, 0)
    if love.keyboard.isDown("w") then
        entity.velocity.y = -1
        entity.direction.y = -1
    end
    if love.keyboard.isDown("s") then
        entity.velocity.y = 1
        entity.direction.y = 1
    end
    if love.keyboard.isDown("a") then
        entity.velocity.x = -1
        entity.direction.x = -1
    end
    if love.keyboard.isDown("d") then
        entity.velocity.x = 1
        entity.direction.x = 1
    end
    if love.keyboard.isDown("j") then
        EventBus:emit("pass", entity)
    end

    if love.keyboard.isDown("k") and InputSystem.k_down == false then
        InputSystem.k_down = true
        EventBus:emit("shoot", entity)
    elseif love.keyboard.isDown("k") == false and InputSystem.k_down then
        InputSystem.k_down = false
    end

    if love.keyboard.isDown("l") and InputSystem.l_down == false then
        InputSystem.l_down = true
        EventBus:emit("switch", nil)
    elseif love.keyboard.isDown("l") == false and InputSystem.l_down then
        InputSystem.l_down = false
    end

    if love.keyboard.isDown("n") and InputSystem.n_down == false then
        InputSystem.n_down = true
        EventBus:emit("tackle", entity)
    elseif love.keyboard.isDown("n") == false and InputSystem.n_down then
        InputSystem.n_down = false
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
