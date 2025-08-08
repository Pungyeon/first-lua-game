local love = require("love")
local Assert = require("scripts/assert/assert")
local Vector = require("scripts/types/vector")

local DebugSystem = {
	players = {},
	on_update = function(_) end,
}

function DebugSystem:init(entities, on_update)
	for _, entity in ipairs(entities) do
		if entity.tag == "puck" then
			self.puck = entity
		end
		if entity.tag == "player" then
			table.insert(self.players, entity)
		end
	end
	self.on_update = on_update
end

function DebugSystem:handle(_)
	if love.keyboard.isDown("1") then
		if not self.step then
			self.step = true
			self.on_update(0.01)
		end
	else
		self.step = false
	end
	if love.keyboard.isDown("2") and not self.play then
		self.play = true
		self.on_update(0.01)
	else
		self.play = false
	end
end

local function or_default(v, default)
	if not v then
		return default
	end
	return v
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
	love.graphics.print(string.format("Possession: %s", possession), 20, 20)
	local y = 35
	for _, player in ipairs(self.players) do
		local travel = or_default(player.travelling_to, Vector:new(-1, -1))
		-- TODO : I need to figure out why the ai is not working. After tackling, they aren't chasing the puck AND it seems that they don't know when they've reached their target position. It's quite annoying and difficult to debug right now.
		local release_stun = 0
		if not Assert.IsZero(player.release_stun) then
			release_stun = player.release_stun
		end
		love.graphics.print(
			string.format(
				"Player: %d, Travelling: %s, Velocity: %s, ReleaseStun: %d",
				player.id,
				travel:string(),
				player.velocity:string(),
				release_stun
			),
			20,
			y
		)
		y = y + 15
	end
end

return DebugSystem

