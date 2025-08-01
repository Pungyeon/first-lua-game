local Game = require("scenes/game")
-- Tasks:
-- - [ ] Enable checking / tackling other players
-- - [ ] Implement Goalie
-- - [ ] Implement 'home' positions for each player
  -- - [ ] Implement Resetting the game after a goal is scored
  -- - [ ] Implement face off ?? :O 
-- - [ ] Draw the ice rink
-- - [ ] Make the ice rink with rounded edges.
-- - [ ] Implement Game Mechanics (Icing, etc.)

local scene = Game

function love.load()
  scene:init()
end

function love.conf(t)
    t.console = true
end

function love.update(dt)
  scene:update(dt)
end

function love.draw()
  scene:draw()
end
