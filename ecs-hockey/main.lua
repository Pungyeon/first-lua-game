local Player = require("scripts/entities/player")
local Puck = require("scripts/entities/puck")
local Wall = require("scripts/entities/wall")
local RenderSystem = require("scripts/systems/render")
local InputSystem = require("scripts/systems/input")
local PhysicsSystem = require("scripts/systems/physics")
local CollisionSystem = require("scripts/systems/collision")
local EventBus = require("scripts/types/event_bus")
local InteractiveSystem = require("scripts/systems/interactive")
local SelectSystem = require("scripts/systems/select")

local screen_width, screen_height = love.window.getMode()
local wall_thickness = 10
local entities = nil
local interactive_system = nil
local select_system = nil

function love.load()
    entities = {
        Puck:new(250, 250),
        Player:new(screen_width * 0.1, 100),
        Player:new(screen_width * 0.8, 100),
        Wall:new(0, 0, screen_width, wall_thickness),
        Wall:new(0, 0, wall_thickness, screen_height),
        Wall:new(screen_width - wall_thickness, 0, wall_thickness, screen_height),
        Wall:new(0, screen_height - wall_thickness, screen_width, screen_height),
    }
    for i = 1, #entities do
        entities[i].id = i
    end
    interactive_system = InteractiveSystem:new(entities)
    select_system = SelectSystem:new(entities)
end

function love.conf(t)
    t.console = true
end

function love.keypressed(key)
end

function love.update(dt)
    InputSystem:handle("UNUSED", entities)
    CollisionSystem:handle(dt, entities)
    PhysicsSystem:handle(dt, entities)
end

function love.draw()
    RenderSystem:handle(entities)
end
