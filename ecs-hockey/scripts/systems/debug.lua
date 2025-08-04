local DebugSystem = {
    players = {},
    puck = nil
}

function DebugSystem:init(entities)
    for _, entity in ipairs(entities) do
        if entity.tag == "puck" then
            self.puck = entity
        end
        if entity.tag == "player" then
            table.insert(self.players, entity)
        end
    end
end

function DebugSystem:handle(dt)
end

function DebugSystem:draw()
    local possession = "NONE"
		if self.puck.attached then
        if self.puck.attached.team.id == 1 then
        possession = "HOME"
       end
       if self.puck.attached.team.id == -1 then
        possession = "AWAY"
       end
    end
    love.graphics.print(
        string.format("Possession: %s", possession), 20, 20
    )
end

return DebugSystem
