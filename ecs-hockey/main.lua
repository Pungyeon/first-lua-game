local Player = require("scripts/entities/player")
local Puck = require("scripts/entities/puck")
local Wall = require("scripts/entities/wall")
local Goal = require("scripts/entities/goal")
local RenderSystem = require("scripts/systems/render")
local InputSystem = require("scripts/systems/input")
local PhysicsSystem = require("scripts/systems/physics")
local CollisionSystem = require("scripts/systems/collision")
local EventBus = require("scripts/types/event_bus")
local Color = require("scripts/types/color")
local Teams = require("scripts/types/teams")
local InteractiveSystem = require("scripts/systems/interactive")
local SelectSystem = require("scripts/systems/select")
local AISystem = require("scripts/systems/ai")

local screen_width, screen_height = love.window.getMode()
local wall_thickness = 10
local entities = nil
local interactive_system = nil
local select_system = nil

local goal_height = 150

-- Tasks:
-- - [ ] Enable checking / tackling other players
-- - [ ] Implement Goalie + Goal
-- - [ ] Implement game mechanics - scoring etc. (big one)
-- - [ ] Fix passing - it's currently fairly broken. You are allowed to pass behind yorself. But it will just get blocked, which is silly

function love.load()
    red_team = { id = Teams.HOME, color = Color.RED }
    blue_team = { id = Teams.AWAY, color = Color.BLUE }
    entities = {
        Puck:new(250, 250),
        Player:new(screen_width * 0.8, 100, red_team),
        Player:new(screen_width * 0.8, 300, red_team),
        -- Player:new(screen_width * 0.8, 500, red_team),
        Player:new(screen_width * 0.1, 400, blue_team),
        -- Player:new(screen_width * 0.1, 200, blue_team),
        -- Player:new(screen_width * 0.1, 100, blue_team),
        Wall:new(0, 0, screen_width, wall_thickness),
        Wall:new(0, 0, wall_thickness, screen_height),
        Wall:new(screen_width - wall_thickness, 0, wall_thickness, screen_height),
        Wall:new(0, screen_height - wall_thickness, screen_width, screen_height),
        Goal:new(50, screen_height/2 + goal_height/2, goal_height, goal_width, red_team)
    }
    for i = 1, #entities do
        entities[i].id = i
    end
    interactive_system = InteractiveSystem:new(entities)
    select_system = SelectSystem:new(red_team, entities)
    AISystem:initialise(entities)
end

function love.conf(t)
    t.console = true
end

function love.keypressed(key)
end

function love.update(dt)
    InputSystem:handle("UNUSED", entities)
    AISystem:handle(dt)
    CollisionSystem:handle(dt, entities)
    PhysicsSystem:handle(dt, entities)
end

function love.draw()
    RenderSystem:handle(entities)
    AISystem:debug()
end
