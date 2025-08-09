local Vector = require("scripts/types/vector")
local Rectangle = require("scripts/types/rectangle")
local AISystem = require("scripts/systems/ai")
local SystemTests = {}

function SystemTests:setup()
  entities = {
		Player:new(center_x + player_width * 2, center_y - player_width / 2, red_team),
		Player:new(center_x - player_width * 3, center_y - player_width / 2, blue_team),
		Player:new(center_x - player_width * 7, center_y - player_width / 2, blue_team),
		Goal:new(home_goal_position, goal_width, goal_height, red_team),
		Goal:new(away_goal_position, goal_width, goal_height, blue_team),
		Puck:new(center_x - (puck_width / 2), center_y - (puck_height / 2), puck_width, puck_height)
	}
	for i = 1, #entities do
		entities[i].id = i
	end

	AISystem:init(entities)

end

function SystemTests:run()
  local start, stop = Vector:new(10, 10), Vector:new(100, 10)
  local rectangle = Rectangle:new(50, 5, 20, 20)
  local intersect = lineRectIntersect(start.x, start.y, stop.x, stop.y, rectangle)

  print(string.format("Testing Line/Rectangle intersect: (expected: true, actual: %s)", intersect))
  assert(intersect)
end

return SystemTests
