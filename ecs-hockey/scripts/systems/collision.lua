local CollisionSystem = {}
local function is_top_collision(a, b)
    return a.velocity.y < 0
        and a.position.y < (b.position.y + b.collision.height)
        and (a.position.x < b.position.x + b.collision.width)
        and (a.position.x + a.collision.width > b.position.x)
end

local function is_bottom_collision(a, b)
    return a.velocity.y > 0
        and a.position.y + a.collision.height > b.position.y
        and (a.position.x < b.position.x + b.collision.width)
        and (a.position.x + a.collision.width > b.position.x)
end

local function is_right_collision(a, b)
    return a.velocity.x > 0
        and a.position.x + a.collision.width > b.position.x
        and (a.position.y < b.position.y + b.collision.height)
        and (a.position.y + a.collision.height > b.position.y)
end

local function is_left_collision(a, b)
    return a.velocity.x < 0
        and a.position.x < b.position.x + b.collision.width
        and (a.position.y < b.position.y + b.collision.height)
        and (a.position.y + a.collision.height > b.position.y)
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
        if player.velocity.x ~= 0 then
            for _, wall in ipairs(walls) do
                if aabb(player, wall) then
                    print("x collision: " .. player.velocity.x .. ", y vel: " .. player.velocity.y)
                    if player.velocity.x > 0 then
                        player.position.x = wall.position.x - player.collision.width
                    else
                        player.position.x = wall.position.x + wall.collision.width
                    end
                    player.velocity.x = 0
                end
            end
        end

        if player.velocity.y ~= 0 then
            for _, wall in ipairs(walls) do
                if aabb(player, wall) then
                    print("y collision: " .. player.velocity.y .. ", x vel: " .. player.velocity.x)
                    if player.velocity.y > 0 then
                        -- player.position.y = wall.position.y - player.collision.height
                    else
                        player.position.y = wall.position.y + wall.collision.height
                        -- player.position.y = wall.position.y + wall.collision.height
                    end
                    player.velocity.y = 0
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
