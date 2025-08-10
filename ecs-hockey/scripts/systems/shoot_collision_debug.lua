local LineCollisionDebugSystem = {
  players = {}
}

function LineCollisionDebugSystem:init(entities)
  for _, entity in ipairs(entities) do
    if entity.tag == "player" then
      table.insert(self.players, entity)
    end
  end
end

function LineCollisionDebugSystem:handle(dt)
  
end