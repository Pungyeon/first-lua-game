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
			local travel = v_or(player.travelling_to, Vector:new(-1, -1))
			local distance = { x = -1, y = -1, direct = -1}
			if travel.x ~= -1 then
				distance = player.position:distance_to(travel)
				
			end
			
			-- TODO : I need to figure out why the ai is not working. After tackling, they aren't chasing the puck AND it seems that they don't know when they've reached their target position. It's quite annoying and difficult to debug right now.
			love.graphics.print(
				string.format(
					"Player: %d, Travelling: %s, Position: %s, Distance: %d",
					player.id, travel:string(), player.position:string(), distance.direct)
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