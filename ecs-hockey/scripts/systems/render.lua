local love = require("love")
local Color = require("scripts/types/color")
local RenderSystem = {}

local screen_width, screen_height = love.window.getMode()

local render_tag_map = {
	score_board = function(entity)
		love.graphics.print(
			string.format("%d - %d", entity.home_team, entity.away_team),
			screen_width / 2,
			screen_height * 0.8
		)
	end,
  circle = function(entity)
		love.graphics.setColor(color.red, color.green, color.blue)
		love.graphics.circle("line", entity.position.x, entity.position.y, entity.radius)
	end,
	rectangle = function(entity)
				love.graphics.setColor(Color.BLUE.red, Color.BLUE.green, Color.BLUE.blue)
				if entity.selected then
					local border = 3
					love.graphics.rectangle(
						"fill",
						entity.position.x - border,
						entity.position.y - border,
						entity.dimensions.width + border * 2,
						entity.dimensions.height + border * 2
					)
				end

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
			local color = Color.GREEN
			if entity.team ~= nil then
				color = entity.team.color
			end

			if entity.color ~= nil then
				color = entity.color
			end

			local fn = render_tag_map[entity.tag]
			if fn then
				fn(entity)
			else
				assert(false)
			end
		end
end

function RenderSystem:handle(entities)
	for i = 1, #entities do
		self:handle_entity(entities[i])
	end
end

return RenderSystem
