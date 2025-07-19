local area = require('area')

Players = {}
Players.__index = Players

function Players:new(players)
	local obj = {
		players = players,
		selected = 1
	}
	setmetatable(obj, self)
	return obj
end

function Players:switch_next()
	self:switch_to(self.selected + 1)
end

function Players:switch_to(to)
	self.players[self.selected]:deselect()
	self.selected = to
	if self.selected > #self.players then
		self.selected = 1
	end
end

function Players:update(dt)	
		self.players[self.selected]:select()

		for i = 1, #self.players do
			self.players[i]:handle_input()
			if self.
			self.players[i]:update(dt)
		end
end

function Players:collision(puck)
	for i = 1, #self.players do
		local player = self.players[i]
		if area.Collision(player, puck) then
			if player:pickup(puck) then
				self:switch_to(i)
			end
		end
	end
end

function Players:draw()
	for i = 1, #self.players do
			self.players[i]:draw()
	end 
end

return Players