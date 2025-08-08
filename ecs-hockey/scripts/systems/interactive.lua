local love = require("love")
local EventBus = require("scripts/types/event_bus")
local Vector = require("scripts/types/vector")
local Rectangle = require("scripts/types/rectangle")
local Teams = require("scripts/types/teams")
local Assert = require("scripts/assert/assert")

InteractiveSystem = {} -- TODO : this name sucks

local function find_nearest(root, nodes)
	local min = nil
	for i = 1, #nodes do
		local node = nodes[i]
		if node.id ~= root.id then
			local distance = node.position:distance_to(root.position)
			if min == nil then
				min = { distance = distance, index = i }
			else
				if distance.direct < min.distance.direct then
					min = { distance = distance, index = i } -- TODO : why are we storing the index ?
				end
			end
		end
	end
	return min
end

function InteractiveSystem:new(entities)
	local obj = {
		players = {},
	}
	for _, entity in ipairs(entities) do
		if entity.tag == "goal" then
			if entity.team.id == Teams.AWAY then
				obj.away_goal = entity
			end
			if entity.team.id == Teams.HOME then
				obj.home_goal = entity
			end
		end
		if entity.tag == "player" then
			table.insert(obj.players, entity)
		end
	end

	setmetatable(obj, self)
	self.__index = self

	EventBus:on("shoot", function(data)
		obj:handle_shoot(data)
	end)

	EventBus:on("pass", function(data)
		obj:handle_pass(data)
	end)

	EventBus:on("tackle", function(data)
		obj:handle_tackle(data.actor, data.victim)
	end)

	return self
end

local function release(root, velocity, speed)
	local puck = root.attached
	puck.velocity = velocity
	puck.speed = speed
	root.attached = nil
	puck.attached = nil
	EventBus:emit("possession", nil)

	root.release_stun = 50 -- this makes sure that the player cannot collide with the puck after release
end

function InteractiveSystem:handle_tackle(actor, victim)
	if not Assert.IsZero(actor.release_stun) then
		return
	end
	if victim then
		self:tackle_player(actor, victim)
		return
	end

	for _, player in ipairs(self.players) do
		if player.id == actor then
			goto continue
		end
		local distance = player.position:distance_to(
			Rectangle:new(actor.position.x, actor.position.y, actor.dimensions.width, actor.dimensions.height):center()
		)
		if math.abs(distance.direct) < 50 then -- This seems ok ?
			self:tackle_player(actor, player)
		end
		::continue::
	end
end

function InteractiveSystem:tackle_player(actor, player)
	player.velocity.x = actor.direction.x
	player.velocity.y = actor.direction.y
	player.collision.bounce = 50

	local puck = player.attached
	if puck then
		actor.release_stun = 10
		release(player, Vector:new(actor.direction.x, actor.direction.y), 100)
		if not actor.selected then
			local distance = puck.position:distance_to(actor.position)
			actor.travelling_to = puck.position
			actor.velocity = Vector:new(distance.x / distance.direct, distance.y / distance.direct)
			actor.direction = actor.velocity:direction()
		end
	end
	-- print(string.format(
	-- "BAM! (%d, %d) %s (selected: %s, %s)",
	-- player.id, actor.id, actor.direction:string(), player.selected, actor.selected)
	-- )
end

function InteractiveSystem:handle_pass(root)
	if root.attached == nil then
		return
	end

	-- TODO : at some point, we will need to also take into account the movement
	-- of the player. i.e if the player is moving down, we should filter out players who are above
	local teammates = {}
	for _, entity in ipairs(self.players) do
		if entity.tag == "player" and entity.team.id == root.team.id then
			table.insert(teammates, entity)
		end
	end

	local nearest = find_nearest(root, teammates)
	if nearest == nil then
		return
	end

	release(
		root,
		Vector:new(nearest.distance.x / nearest.distance.direct, nearest.distance.y / nearest.distance.direct),
		500
	)
end

function InteractiveSystem:handle_shoot(entity)
	if entity.attached == nil then
		return
	end

	local goal = nil
	if entity.team.id == Teams.AWAY then
		goal = self.away_goal
	end
	if entity.team.id == Teams.HOME then
		goal = self.home_goal
	end

	if not goal then
		release(entity, Vector:new(entity.velocity.x, entity.velocity.y), 1000)
		return
	end

	local target = Vector:new(
		goal.position.x + (goal.dimensions.width * entity.team.id),
		love.math.random(goal.position.y, goal.position.y + goal.dimensions.height)
	)

	local distance = target:distance_to(entity.position)
	local vec = Vector:new(distance.x / distance.direct, distance.y / distance.direct)
	release(entity, vec, 1000)
end

return InteractiveSystem
