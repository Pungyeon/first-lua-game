local area = require('area')

Players = {}
Players.__index = Players

function Players:new(players)
	local obj = {
		players = players,
		select = 1
	}
	setmetatable(obj, self)
	return obj
end

function Players:switch_to(to)
	self.players[selected]:deselect()
	self.selected = to
	if self.selected > #players then
		self.selected = 1
	end
end

function Players:update(dt)
		self.players[self.selected]:select()

		for i = 1, #self.players do
			self.players[i]:update(dt)
		end
end

function Players:collision(puck)
	for i = 1, #selfplayers do
		local player = self.players[i]
		if area.Collision(player, puck) then 
			player:pickup(puck)
			self.switch_to(i)
		end
	end
end

function Players:draw()
	for i = 1, #players do
			players[i]:draw()
	end 
end

return Players