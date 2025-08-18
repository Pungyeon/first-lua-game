local love = require("love")
love.window.setMode(1280, 960)

local Game = require("scenes/game")
local Bounce = require("scenes/bounce")
local Tackle = require("scenes/tackle")
local Reset = require("scenes/reset")
local Rink = require("scenes/rink")
local EventBus = require("scripts/types/event_bus")
local SystemTests = require("scripts/systems/test")
-- Bugs:
-- - [x] Now that we are using directions for input, we need to set this with the ai systems as well.
-- Tasks:
-- - [x] Enable checking / tackling other players
-- - [ ] Implement Goalie
-- - [x] Implement 'home' positions for each player
-- - [x] Implement Resetting the game after a goal is scored
--   - [x] Implement a goal celebration event ?
--   -   [ ] Expand on this so that they actually do some celebrating?
-- - [ ] Implement face off ?? :O
-- - [ ] Draw the ice rink
-- - [ ] Make the ice rink with rounded edges.
-- - [ ] Implement Game Mechanics (Icing, etc.)

local scene = Rink

function love.keypressed(key)
	if key == "1" then
		scene = Game
	elseif key == "2" then
		scene = Bounce
	elseif key == "3" then
		scene = Tackle
	elseif key == "4" then
		scene = Reset
	elseif key == "5" then
		scene = Rink
	elseif key == "0" then
		EventBus:emit("reset", { complete = false })
		return
	else
		return
	end
	love.load()
end

function love.load()
	SystemTests:run()
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
