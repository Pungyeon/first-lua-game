local globals = {
	InputMap = {
    w = function(p) p.vy = p.vy - 1 end,
    s = function(p) p.vy = p.vy + 1 end,
    a = function(p) p.vx = p.vx - 1 end,
		d = function(p) p.vx = p.vx + 1 end
	}
}

return globals