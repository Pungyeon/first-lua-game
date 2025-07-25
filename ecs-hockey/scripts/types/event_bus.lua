local EventBus = {
    listeners = {}
}

function EventBus:on(type, callback)
    if not self.listeners[type] then
        self.listeners[type] = {}
    end
    table.insert(self.listeners[type], callback)
end

function EventBus:emit(type, data)
    local listeners = self.listeners[type]
    for _, callback in ipairs(listeners) do
        callback(data)
    end
end

return EventBus
