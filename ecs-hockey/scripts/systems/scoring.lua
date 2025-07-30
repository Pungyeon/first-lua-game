local EventBus = require("scripts/types/event_bus")
local Teams = require("scripts/types/teams")

local ScoringSystem = {
  home_team = 0,
  away_team = 0
}

function ScoringSystem:init()
  EventBus:on("goal", function(data)
    if data.state then
      return
    end

    if data.team.id == Teams.AWAY then
      self.home_team = self.home_team + 1
    end
    if data.team.id == Teams.HOME then
      self.away_team = self.away_team + 1
    end
    data.state = {} 
    print(string.format("Goal ! %d", data.team.id))
  end)
end

return ScoringSystem
