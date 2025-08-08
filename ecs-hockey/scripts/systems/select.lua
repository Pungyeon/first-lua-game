local EventBus = require("scripts/types/event_bus")

local SelectSystem = {} -- TODO : this name sucks

function SelectSystem:new(team, entities)
	local players = {}
	for _, entity in ipairs(entities) do
		if entity.tag == "player" and entity.team.id == team.id then
			table.insert(players, entity)
		end
	end

	local obj = {
		players = players,
		selected = 1,
	}
	setmetatable(obj, self)
	self.__index = self

	EventBus:on("switch", function(data)
		obj:handle_switch(data)
	end)

	EventBus:on("reset", function(data)
		if data.complete then
			obj:switch_to(1)
		end
	end)

	EventBus:emit("switch", nil)

	return self
end

function SelectSystem:switch_to(i)
	if self.players[self.selected] then
		self.players[self.selected].selected = nil
	end

	self.selected = i
	if self.selected > #self.players then
		self.selected = 1
	end

	self.players[self.selected].selected = {}
end

function SelectSystem:handle_switch(player)
	if player ~= nil then
		if player.team.id ~= self.players[self.selected].team.id then
			return
		end
		for i = 1, #self.players do
			if self.players[i].id == player.id then
				self:switch_to(i)
				return
			end
		end
	end

	self:switch_to(self.selected + 1)
end

return SelectSystem
