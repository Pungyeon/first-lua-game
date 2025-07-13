local inputMap = {
    w = function(p) p.vy = p.vy - 1 end,
    s = function(p) p.vy = p.vy + 1 end,
    a = function(p) p.vx = p.vx - 1 end,
    d = function(p) p.vx = p.vx + 1 end
}

InputComponent = {}
InputComponent.__index = InputComponent

function InputComponent:new(inputMap)
    local obj = { map = inputMap }
    setmetatable(obj, self)
    return obj
end

function InputComponent:update(node)
    node.vx, node.vy = 0, 0
    for key, action in pairs(self.map) do
        if love.keyboard.isDown(key) then
            action(node)
        end
    end

    local mag = math.sqrt(node.vx^2 + node.vy^2)
    if mag > 0 then
        node.vx = node.vx / mag
        node.vy = node.vy / mag
    end
end



return InputComponent