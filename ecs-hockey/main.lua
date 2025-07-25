local Player = require("scripts/entities/player")
local Input = require("scripts/components/input")
local RenderSystem = require("scripts/systems/render")
local InputSystem = require("scripts/systems/input")
local PhysicsSystem = require("scripts/systems/physics")

local screen_width, screen_height = love.window.getMode()

local entities = nil
local render_system = nil
local input_system = nil
local physics_system = nil

function love.load()
    entities = {
        Player:new(100, 100, Input:new())
    }
    render_system = RenderSystem:new()
    input_system = InputSystem:new()
    physics_system = Physics:new()
end

function love.keypressed(key)
end

function love.update(dt)
    input_system:handle(entities)
    physics_system:handle(dt, entities)
end

function love.draw()
    render_system:handle(entities)
end
