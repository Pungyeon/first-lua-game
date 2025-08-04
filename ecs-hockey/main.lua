local love = require("love")
local Game = require("scenes/game")
local Bounce = require("scenes/bounce")
local Tackle = require("scenes/tackle")
-- Bugs:
-- - [ ] Now that we are using directions for input, we need to set this with the ai systems as well.
-- Tasks:
-- - [ ] Enable checking / tackling other players
-- - [ ] Implement Goalie
-- - [ ] Implement 'home' positions for each player
  -- - [ ] Implement Resetting the game after a goal is scored
  -- - [ ] Implement face off ?? :O 
-- - [ ] Draw the ice rink
-- - [ ] Make the ice rink with rounded edges.
-- - [ ] Implement Game Mechanics (Icing, etc.)

-- local scene = Game
-- local scene = Bounce
local scene = Tackle

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
