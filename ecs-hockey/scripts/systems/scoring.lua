local EventBus = require("scripts/types/event_bus")
local Teams = require("scripts/types/teams")

local ScoringSystem = {
  score_board = nil
}

function ScoringSystem:init(score_board)
  self.score_board = score_board

  EventBus:on("goal", function(data)
    if data.state then
      return
    end

    if data.team.id == Teams.AWAY then
      self.score_board.home_team = self.score_board.home_team + 1
    end
    if data.team.id == Teams.HOME then
      self.score_board.away_team = self.score_board.away_team + 1
    end
    -- data.state = {} 
    print(string.format("Goal ! %d", data.team.id))
    EventBus:emit("reset", { complete = false })
  end)
end

return ScoringSystem
