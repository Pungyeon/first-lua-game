local Color = require("scripts/types/color")
RenderSystem = {}

local function ternary(cond, a, b)
    if cond then return a else return b end
end

function RenderSystem:handle(entities)
    for i = 1, #entities do
        local entity = entities[i]
        if entity.render then
            local color = ternary(entity.color, entity.color, Color.WHITE)
            if entity.render.type == "rectangle" then
                love.graphics.setColor(Color.BLUE.red, Color.BLUE.green, Color.BLUE.blue)
                if entity.selected then
                    local border = 3
                    love.graphics.rectangle("fill",
                        entity.position.x - border,
                        entity.position.y - border,
                        entity.dimensions.width + border * 2,
                        entity.dimensions.height + border * 2
                    )
                end

                love.graphics.setColor(color.red, color.green, color.blue)
                love.graphics.rectangle("fill",
                    entity.position.x,
                    entity.position.y,
                    entity.dimensions.width,
                    entity.dimensions.height
                )
            end
        end
    end
end

return RenderSystem
