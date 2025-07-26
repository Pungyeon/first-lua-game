local Player = require("scripts/entities/player")
local Wall = require("scripts/entities/wall")
local RenderSystem = require("scripts/systems/render")
local InputSystem = require("scripts/systems/input")
local PhysicsSystem = require("scripts/systems/physics")
local CollisionSystem = require("scripts/systems/collision")

local screen_width, screen_height = love.window.getMode()

local entities = nil
local render_system = nil
local input_system = nil
local physics_system = nil

local wall_thickness = 10

function love.load()
    entities = {
        Player:new(100, 100),
        Wall:new(0, 0, screen_width, wall_thickness),
        Wall:new(0, 0, wall_thickness, screen_height),
        Wall:new(screen_width - wall_thickness, 0, wall_thickness, screen_height),
        Wall:new(0, screen_height - wall_thickness, screen_width, screen_height),
    }
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
