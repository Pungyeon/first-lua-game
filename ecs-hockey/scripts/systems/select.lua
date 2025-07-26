local EventBus = require("scripts/types/event_bus")
local Vector = require("scripts/types/vector")

SelectSystem = {} -- TODO : this name sucks

function SelectSystem:new(entities)
    local players = {}
    for _, entity in ipairs(entities) do
        if entity.tag == "player" then
            table.insert(players, entity)
        end
    end

    local obj = {
        players = players,
        selected = 1
    }
    setmetatable(obj, self)
    self.__index = self

    EventBus:on("switch", function(data)
        obj:handle_switch(data)
    end)

    EventBus:emit("switch", nil)

    return self
end

function SelectSystem:switch_to(i)
    if self.selected > #self.players then
        self.selected = 1
    end
    self.players[self.selected].selected = nil
    self.players[self.selected].velocity = Vector:new(0, 0)

    self.selected = i
    self.players[self.selected].selected = {}
end

function SelectSystem:handle_switch(player)
    if player ~= nil then
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
