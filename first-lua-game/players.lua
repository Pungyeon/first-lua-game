Players = {}
Players.__index = Players

function Players:new(players)
	self.players = players
	self.select = 1
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
	for i = 1, #players do
	local player = players[i]
			if area.Collision(player, puck) then 
				player:pickup(puck)
				switch_player(i)
			end
		end
end