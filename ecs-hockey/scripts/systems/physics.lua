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
        if entity.physics and entity.physics.type == "simple" then
            handle_simple(dt, entity)
            if entity.attached then
                if entity.direction.x > 0 then
                    entity.attached.position.x = entity.position.x + entity.dimensions.width
                end
                if entity.direction.x < 0 then
                    entity.attached.position.x = entity.position.x - entity.attached.dimensions.width
                end
                entity.attached.position.y = entity.position.y + entity.dimensions.height / 2
            end
        end
        if entity.physics and entity.physics.type == "particle" and entity.attached == nil then
            handle_simple(dt, entity)
            if entity.speed > 0 then
                entity.speed = entity.speed - (100 * dt)
            else
                entity.speed = 0
            end
        end
    end
end

return PhysicsSystem
