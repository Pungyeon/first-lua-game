-- Entities
local Player = require("scripts/entities/player")
local Wall = require("scripts/entities/wall")
local Area = require("scripts/entities/area")

-- Systems
local RenderSystem = require("scripts/systems/render")
local InputSystem = require("scripts/systems/input")
local PhysicsSystem = require("scripts/systems/physics")
local CollisionSystem = require("scripts/systems/collision")
local InteractiveSystem = require("scripts/systems/interactive")
local EffectsSystem = require("scripts/systems/effects")
local SelectSystem = require("scripts/systems/select")
local AISystem = require("scripts/systems/ai")

-- Types
local Color = require("scripts/types/color")
local Teams = require("scripts/types/teams")

-- Main
local Tackle = {}

local screen_width, screen_height = love.window.getMode()
local line_width = 5
local center_y = screen_height/2
local center_x = screen_width/2
local player_width = 30
local wall_thickness = 10
local entities = nil
local puck_width = 10
local puck_height = 10

function Tackle:init()
    local red_team = { id = Teams.HOME, color = Color.RED }
    local blue_team = { id = Teams.AWAY, color = Color.BLUE }
    local puck = Puck:new(center_x-(puck_width/2), center_y-(puck_height/2), puck_width, puck_height)
    puck.velocity.x = 0.2
    entities = {
        Area:new(center_x-line_width, 0, line_width, screen_height, Color.DARK_RED),
        Player:new(
          center_x+player_width*2,
          center_y-player_width/2,
          red_team),
        Player:new(
          center_x-player_width*3,
          center_y-player_width/2,
          blue_team),
        Wall:new(0, 0, screen_width, wall_thickness),
        Wall:new(0, 0, wall_thickness, screen_height),
        Wall:new(screen_width - wall_thickness, 0, wall_thickness, screen_height),
        Wall:new(0, screen_height - wall_thickness, screen_width, screen_height),
        puck
    }
    for i = 1, #entities do
        entities[i].id = i
    end
  
    local interactive_system = InteractiveSystem:new(entities)
    local select_system = SelectSystem:new(red_team, entities)
    AISystem:init(entities)
    EffectsSystem:init(entities)
end

function Tackle:update(dt)
    EffectsSystem:handle(dt)
    InputSystem:handle("UNUSED", entities)
    CollisionSystem:handle(dt, entities)
    PhysicsSystem:handle(dt, entities)
		AISystem:handle(dt)
end

function Tackle:draw()
    RenderSystem:handle(entities)
end

return Tackle
