local love = require("love")
local Color = require("scripts/types/color")
local RenderSystem = {}

local screen_width, screen_height = love.window.getMode()

local render_tag_map = {
	score_board = function(color, entity)
		love.graphics.setColor(color.red, color.green, color.blue)
		love.graphics.print(
			string.format("%d - %d", entity.home_team, entity.away_team),
			screen_width / 2,
			screen_height * 0.8
		)
	end,
  circle = function(color, entity)
		love.graphics.setColor(color.red, color.green, color.blue)
		love.graphics.setLineWidth(5)
		love.graphics.circle("line", entity.position.x, entity.position.y, entity.radius)
	end,
	rectangle = function(color, entity)
				if entity.selected then
					love.graphics.setColor(Color.BLUE.red, Color.BLUE.green, Color.BLUE.blue)
					local border = 3
					love.graphics.rectangle(
						"fill",
						entity.position.x - border,
						entity.position.y - border,
						entity.dimensions.width + border * 2,
						entity.dimensions.height + border * 2
					)
				end

				print(color)
				love.graphics.setColor(color.red, color.green, color.blue)
				love.graphics.rectangle(
					"fill",
					entity.position.x,
					entity.position.y,
					entity.dimensions.width,
					entity.dimensions.height
				)
				love.graphics.setColor(0, 0, 0)
				love.graphics.print(entity.id, entity.position.x, entity.position.y)
	end,
}

function RenderSystem:handle_entity(entity)
		if entity.render then
			local color = nil
			if entity.team ~= nil then
				color = entity.team.color
			end

			if entity.color ~= nil then
				color = entity.color
			end
			
			assert(color, string.format("Color nil (%s): (render type: %s, tag: %s)",
				color, entity.render.type, entity.tag))

			local fn = render_tag_map[entity.render.type]
			if fn then
				fn(color, entity)
			else
				assert(false, "could not find tag in render map: " .. entity.render.type)
			end
		end
end

function RenderSystem:handle(entities)
	for i = 1, #entities do
		self:handle_entity(entities[i])
	end
end

return RenderSystem
