return {
    NotNil = function(obj, msg)
        if obj == nil then
            error(msg)
        end
    end
}
