return {
	NotNil = function(obj, msg)
		if obj == nil then
			error(msg)
		end
	end,
	IsZero = function(obj)
		if obj == nil then
			return true
		end
		if obj == 0 then
			return true
		end
		return false
	end,
}
