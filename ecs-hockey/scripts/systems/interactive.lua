local EventBus = require("scripts/types/event_bus")
local Vector = require("scripts/types/vector")

InteractiveSystem = {} -- TODO : this name sucks

local function find_nearest(root, nodes)
    local min = nil
    for i = 1, #nodes do
        local node = nodes[i]
        if node.id ~= root.id then
            local distance = node.position:distance_to(root.position)
            if min == nil then
                min = { distance = distance, index = i }
            else
                if distance.direct < min.distance.direct then
                    min = { distance = distance, index = i } -- TODO : why are we storing the index ?
                end
            end
        end
    end
    return min
end

function InteractiveSystem:new(entities)
    local obj = {
        entities = entities
    }
    setmetatable(obj, self)
    self.__index = self

    EventBus:on("shoot", function(data)
        obj:handle_shoot(data)
    end)

    EventBus:on("pass", function(data)
        obj:handle_pass(data)
    end)

    return self
end

function InteractiveSystem:handle_pass(root)
    if root.attached == nil then
        return
    end

    -- TODO : at some point, we will need to also take into account the movement
    -- of the player. i.e if the player is moving down, we should filter out players who are above
    local teammates = {}
    for _, entity in ipairs(self.entities) do
        if entity.tag == "player" and entity.color == root.color then
            table.insert(teammates, entity)
        end
    end

    local nearest = find_nearest(root, teammates)
    if nearest == nil then
        return
    end
    local puck = root.attached
    puck.velocity = Vector:new(
        nearest.distance.x / nearest.distance.direct,
        nearest.distance.y / nearest.distance.direct
    )
    puck.speed = 500
    root.attached = nil
    puck.attached = nil
end

function InteractiveSystem:handle_shoot(entity)
    if entity.attached == nil then
        return
    end

    local puck = entity.attached
    puck.velocity = Vector:new(entity.velocity.x, entity.velocity.y)
    puck.speed = 1000
    puck.attached = nil
    entity.attached = nil
end

return InteractiveSystem
