local love = require("love")
local Game = require("scenes/game")
local Bounce = require("scenes/bounce")
local Tackle = require("scenes/tackle")
local Reset = require("scenes/reset")
local EventBus = require("scripts/types/event_bus")
-- Bugs:
-- - [x] Now that we are using directions for input, we need to set this with the ai systems as well.
-- Tasks:
-- - [x] Enable checking / tackling other players
-- - [ ] Implement Goalie
-- - [x] Implement 'home' positions for each player
  -- - [x] Implement Resetting the game after a goal is scored
--   - [x] Implement a goal celebration event ? 
  -- - [ ] Implement face off ?? :O 
-- - [ ] Draw the ice rink
-- - [ ] Make the ice rink with rounded edges.
-- - [ ] Implement Game Mechanics (Icing, etc.)

local scene = Reset

function love.keypressed(key)
  if key == "1" then
    scene = Game
  elseif key == "2" then
    scene = Bounce
  elseif key == "3" then
    scene = Tackle
  elseif key == "4" then
    scene = Reset
  elseif key == "0" then
    EventBus:emit("reset", { complete = false })
    return
  else
    return
  end
  love.load()
end

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
