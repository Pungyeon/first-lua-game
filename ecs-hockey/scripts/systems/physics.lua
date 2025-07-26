local Assert = require("scripts/assert/assert")

PhysicsSystem = {}

local function handle_simple(dt, entity)
    Assert.NotNil(entity.position, "no position on given object - required for simple_physics")
    Assert.NotNil(entity.velocity, "no velocity on given object - required for simple_physics")
    Assert.NotNil(entity.speed, "no speed on given object - required for simple_physics")

    entity.position.x = entity.position.x + (entity.velocity.x * dt * entity.speed)
    entity.position.y = entity.position.y + (entity.velocity.y * dt * entity.speed)
end

function PhysicsSystem:handle(dt, entities)
    for i = 1, #entities do
        local entity = entities[i]
        if entity.physics then
            -- TODO : separate on phsyics.tag
            handle_simple(dt, entity)
        end
    end
end

return PhysicsSystem
