local EventBus = require("scripts/types/event_bus")
local CollisionSystem = {
  pause = false
}

EventBus:on("reset", function(data)
  CollisionSystem.pause = not data.complete
end)

local function contains(outer, inner)
  return inner.position.x >= outer.position.x and
      inner.position.y >= outer.position.y and
      inner.position.x + inner.dimensions.width <= outer.position.x + outer.dimensions.width and
      inner.position.y + inner.dimensions.height <= outer.position.y + outer.dimensions.height
end

local function aabb(a, b)
    return a.position.x < b.position.x + b.collision.width and
        a.position.x + a.collision.width > b.position.x and
        a.position.y < b.position.y + b.collision.height and
        a.position.y + a.collision.height > b.position.y
end

local function handle_rigid_collision(dt, entity, static)
    local predict = {
        position = Vector:new(
            entity.position.x + (entity.velocity.x * entity.speed * dt),
            entity.position.y
        ),
        collision = entity.collision,
    }
    local result = { x = false, y = false, entity = entity, static = static, velocity = entity.velocity:copy() }

    if aabb(predict, static) then
        if entity.collision.type == "rigid" then
            result.x = true
            result.velocity.x = result.velocity.x * -1
            entity.velocity.x = 0
        else
            error("unsupported collision type: " .. entity.collision.type)
        end
        predict.position.x = entity.position.x
    end

    predict.position.y = entity.position.y + (entity.velocity.y * entity.speed * dt)
    if aabb(predict, static) then
        if entity.collision.type == "rigid" then
            result.y = true
            result.velocity.y = result.velocity.y * -1
            entity.velocity.y = 0
        else
            error("unsupported collision type: " .. entity.collision.type)
        end
    end
    if result.x or result.y then
        EventBus:emit("collision", result)
    end
end

local function handle_static_collision(dt, entity, static)
    local predict = {
        position = Vector:new(
            entity.position.x + (entity.velocity.x * entity.speed * dt),
            entity.position.y
        ),
        collision = entity.collision,
    }
    if aabb(predict, static) then
        if entity.collision.type == "rigid" then
            entity.velocity.x = 0
        elseif entity.collision.type == "particle" then
            entity.velocity.x = entity.velocity.x * -1
            entity.speed = entity.speed * static.slowdown
        else
            error("unsupported collision type: " .. entity.collision.type)
        end
        predict.position.x = entity.position.x
    end

    predict.position.y = entity.position.y + (entity.velocity.y * entity.speed * dt)
    if aabb(predict, static) then
        if entity.collision.type == "rigid" then
            entity.velocity.y = 0
        elseif entity.collision.type == "particle" then
            entity.velocity.y = entity.velocity.y * -1
            entity.speed = entity.speed * 0.75
            -- TODO : should we also decrease speed ?
        else
            error("unsupported collision type: " .. entity.collision.type)
        end
    end
end

local function handle_goal_collision(dt, entity, goal)
  if entity.tag == "puck" then
    if contains(goal, entity) then
      EventBus:emit("goal", goal)
    end
  end
end

function CollisionSystem:handle(dt, entities)
    if self.pause then
      return
    end
    local walls = {}   -- TODO : rename this to static
    local players = {} -- TODO : rename this to rigid
    local particles = {}
    local goals = {}
    for _, entity in ipairs(entities) do
        if entity.collision then
            if entity.collision.type == "goal" then
              table.insert(goals, entity)
            end 
            if entity.collision.type == "static" then
                table.insert(walls, entity)
            end
            if entity.collision.type == "rigid" then
                table.insert(players, entity)
            end
            if entity.collision.type == "particle" then
                table.insert(particles, entity)
            end
        end
    end

    for _, particle in ipairs(particles) do
      for _, goal in ipairs(goals) do      
        handle_goal_collision(dt, particle, goal)
      end
    end

    for _, particle in ipairs(particles) do
        if particle.attached then
            goto continue
        end

        for _, wall in ipairs(walls) do
            handle_static_collision(dt, particle, wall)
        end
        ::continue::
    end

    for _, player in ipairs(players) do
        for _, wall in ipairs(walls) do
            handle_static_collision(dt, player, wall)
        end
    end

    -- TODO : I'm not sure this is the best way of oding this, but it works for now.
    for _, player in ipairs(players) do
        for _, goal in ipairs(goals) do
            -- TODO : i don't think that this is ideal, but whatever for now
--          --  we are as good as vibe coding, omega-lul
            handle_static_collision(dt, player, goal)
        end
    end

    for _, player in ipairs(players) do
        if player.release_stun and player.release_stun > 0 then
          goto continue_player
        end
        for _, particle in ipairs(particles) do
            if particle.attached then
                goto continue
            end
            if aabb(player, particle) then
                if player.attached == nil then
                    player.attached = particle
                    particle.attached = player
                    EventBus:emit("switch", player)
                    EventBus:emit("possession", player)
                end
            end
            ::continue::
        end
        ::continue_player::
    end

    for i = 1, #players do
        local a = players[i]
        for j = 1, #players do
            local b = players[j]
            if a.id ~= b.id then
                handle_rigid_collision(dt, a, b)
            end
        end
    end
end

return CollisionSystem
