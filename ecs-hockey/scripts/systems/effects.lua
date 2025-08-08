local Vector = require("scripts/types/vector")

local EffectsSystem = {
	players = {},
}

function EffectsSystem:init(entities)
	for _, entity in ipairs(entities) do
		if entity.tag == "player" then
			table.insert(self.players, entity)
		end
	end
end

function EffectsSystem:handle(_)
	-- TODO : do we need to use dt in our calculations as well ? I suppose we do
	for _, player in ipairs(self.players) do
		if player.collision and player.collision.bounce > 0 then
			player.collision.bounce = player.collision.bounce - 1
			if player.collision.bounce == 0 then
				player.velocity = Vector:new(0, 0)
			end
		end
		if player.release_stun and player.release_stun > 0 then
			player.release_stun = player.release_stun - 1
		end
	end
end

return EffectsSystem
