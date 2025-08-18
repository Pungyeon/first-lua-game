local Vector = require("scripts/types/vector")

local Goalie = {}

function Goalie:new(x, y, team)
	return {
		team = team,
		speed = 100,
		reset_position = Vector:new(x, y),
		position = Vector:new(x, y),
		velocity = Vector:new(0, 0),
		render = { type = "rectangle" },
		physics = { type = "simple" },
		dimensions = { width = 30, height = 30 },
		collision = { type = "rigid", width = 30, height = 30, bounce = 0 },
		direction = Vector:new(team.id, 0),
		tag = "goalie",
	}
end

return Goalie
