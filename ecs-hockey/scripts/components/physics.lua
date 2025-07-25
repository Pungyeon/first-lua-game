local Assert = require("scripts/assert/assert")

SimplePhysics = {}
SimplePhysics.__index = SimplePhysics

function SimplePhysics:new()
    local obj = {}
    setmetatable(obj, self)
    return obj
end

function SimplePhysics:handle(dt, entity)
    Assert.NotNil(entity.position, "no position on given object - required for simple_physics")
    Assert.NotNil(entity.velocity, "no velocity on given object - required for simple_physics")
    Assert.NotNil(entity.speed, "no speed on given object - required for simple_physics")

    entity.position.x = entity.position.x + (entity.velocity.x * dt * entity.speed)
    entity.position.y = entity.position.y + (entity.velocity.y * dt * entity.speed)
end

return SimplePhysics
