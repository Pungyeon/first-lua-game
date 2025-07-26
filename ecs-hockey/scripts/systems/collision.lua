local CollisionSystem = {}

function aabb(a, b)
    return a.position.x < b.position.x + b.collision.width and
        a.position.x + a.collision.width > b.position.x and
        a.position.y < b.position.y + b.collision.height and
        a.position.y + a.collision.height > b.position.y
end

function CollisionSystem:handle(dt, entities)
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
            local predict = {
                position = Vector:new(
									player.position.x + (player.velocity.x * player.speed * dt),
									player.position.y
								),
                collision = player.collision,
            }
            if aabb(predict, wall) then
                player.velocity.x = 0
                predict.position.x = player.position.x
            end

            predict.position.y = player.position.y + (player.velocity.y * player.speed * dt)
            if aabb(predict, wall) then
                player.velocity.y = 0
            end
        end
    end
end

return CollisionSystem
