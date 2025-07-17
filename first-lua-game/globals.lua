local globals = {
	InputMap = {
    w = function(p) p.vy = p.vy - 1 end,
    s = function(p) p.vy = p.vy + 1 end,
    a = function(p) 
			p.vx = p.vx - 1 
			p.direction = -1
		end,
		d = function(p)
			p.vx = p.vx + 1
			p.direction = 1
		end
		space = function(p) p:shoot() end
	}
}

return globals