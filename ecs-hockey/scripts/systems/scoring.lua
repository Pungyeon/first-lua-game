local EventBus = require("scripts/types/event_bus")
local Teams = require("scripts/types/teams")

local ScoringSystem = {
	score_board = nil,
	countdown = 0,
}

function ScoringSystem:init(score_board)
	self.score_board = score_board

	EventBus:on("goal", function(data)
		if self.countdown > 0 then
			return
		end

		if data.team.id == Teams.AWAY then
			self.score_board.home_team = self.score_board.home_team + 1
		end
		if data.team.id == Teams.HOME then
			self.score_board.away_team = self.score_board.away_team + 1
		end
		print(string.format("Goal ! %d", data.team.id))
		self.countdown = 100
	end)
end

function ScoringSystem:handle(_)
	if self.countdown > 0 then
		self.countdown = self.countdown - 1
		print(string.format("Celebration Countdown: %s", self.countdown))
		if self.countdown == 0 then
			print("sending reset")
			EventBus:emit("reset", { complete = false })
		end
	end
end

return ScoringSystem
