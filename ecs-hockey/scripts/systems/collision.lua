local CollisionSystem = {}
local function is_top_collision(a, b)
    return a.velocity.y < 0
        and a.position.y < (b.position.y + b.collision.height)
        and ((a.position.x < b.position.x + b.collision.width) or (a.position.x + a.collision.width > b.position.x))
end

local function is_bottom_collision(a, b)
    return a.velocity.y > 0
        and a.position.y + a.collision.height > b.position.y
        and ((a.position.x < b.position.x + b.collision.width) or (a.position.x + a.collision.width > b.position.x))
end

local function is_right_collision(a, b)
    return a.velocity.x > 0
        and a.position.x + a.collision.width > b.position.x
        and ((a.position.y < b.position.y + b.collision.height) or (a.position.y + a.collision.height > b.position.y))
end

local function is_left_collision(a, b)
    return a.velocity.x < 0
        and a.position.x < b.position.x + b.collision.width
        and ((a.position.y < b.position.y + b.collision.height) or (a.position.y + a.collision.height > b.position.y))
end

local function collision_result(a, b)
    return {
        top = is_top_collision(a, b),
        right = is_right_collision(a, b),
        left = is_left_collision(a, b),
        bottom = is_bottom_collision(a, b),
    }
end

function CollisionSystem:handle(entities)
    local walls = {}
    local players = {}
    for _, entity in ipairs(entities) do
        if entity.tag == "wall" then
            table.insert(walls, entity)
        end
        if entity.tag == "player" then
            table.insert(players, entity)
        end
    end

    for _, player in ipairs(players) do
        for _, wall in ipairs(walls) do
            if aabb(player, wall) then
                local result = collision_result(player, wall)
                if result.top then
                    player.position.y = wall.position.y + wall.collision.height
                end
                if result.bottom then
                    player.position.y = wall.position.y - player.collision.height
                end
                if result.right then
                    player.position.x = wall.position.x - player.collision.width
                end
                if result.left then
                    player.position.x = wall.position.x + wall.collision.width
                end
            end
        end
    end
end

function aabb(a, b)
    return a.position.x < b.position.x + b.collision.width and
        a.position.x + a.collision.width > b.position.x and
        a.position.y < b.position.y + b.collision.height and
        a.position.y + a.collision.height > b.position.y
end

return CollisionSystem
