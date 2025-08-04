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
		local y = 35
		for _, player in ipairs(self.players) do
			local nvec = Vector:new(-1, -1)
			
			

			love.graphics.print(
				string.format(
					"Player: %d, Travelling: %s, ",
					player.id, v_or(player.travelling_to, nvec):string())
, 20, y)
			y = y + 15
		end
end

function v_or(v, default) 
	if not v then
		return default
	end
	return v
end

return DebugSystem
