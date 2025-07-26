local EventBus = require("scripts/types/event_bus")
local Assert = require("scripts/assert/assert")

AISystem = {
    possession = nil,
    puck = nil
}

function AISystem:initialise(entities)
    self.team_to_players = {}
    for _, entity in ipairs(entities) do
        if entity.tag == "puck" then
            self.puck = entity
        end
        if entity.tag == "player" then
            local key = entity.team.id
            if self.team_to_players[key] == nil then
                self.team_to_players[key] = {}
            end
            table.insert(self.team_to_players[key], entity)
        end
    end

    Assert.NotNil(self.puck, "no puck found for AISystem")

    EventBus:on("possession", function(entity)
        self.possession = entity
    end)
end

function AISystem:handle(dt)
    for team, players in ipairs(self.team_to_players) do
        for _, player in ipairs(players) do
            if player.selected == nil then
                local distance = self.puck.position:distance_to(player.position)
                -- local distance = player.position:distance_to(self.puck.position)
                player.velocity = Vector:new(
                    distance.x / distance.direct,
                    distance.y / distance.direct
                )
            end
        end
    end
end

return AISystem
