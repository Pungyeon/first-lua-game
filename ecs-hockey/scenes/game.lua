local love = require("love")
local Player = require("scripts/entities/player")
local Puck = require("scripts/entities/puck")
local Wall = require("scripts/entities/wall")
local Goal = require("scripts/entities/goal")
local Area = require("scripts/entities/area")
local RenderSystem = require("scripts/systems/render")
local InputSystem = require("scripts/systems/input")
local PhysicsSystem = require("scripts/systems/physics")
local CollisionSystem = require("scripts/systems/collision")
local EventBus = require("scripts/types/event_bus")
local Color = require("scripts/types/color")
local Teams = require("scripts/types/teams")
local InteractiveSystem = require("scripts/systems/interactive")
local EffectsSystem = require("scripts/systems/effects")
local SelectSystem = require("scripts/systems/select")
local AISystem = require("scripts/systems/ai")
local ScoringSystem = require("scripts/systems/scoring")

local screen_width, screen_height = love.window.getMode()
local wall_thickness = 10
local interactive_system = nil
local select_system = nil

local goal_height = 150
local goal_width = 60
local home_goal_position = Vector:new(60, (screen_height/2) - (goal_height/2))
local post_thickness = 10
local away_goal_position = Vector:new(screen_width - 60 - goal_width, (screen_height/2) - (goal_height/2))
local line_width = 5
local center_y = screen_height/2
local center_x = screen_width/2
local player_width = 30
local player_height = 30
local puck_width = 10
local puck_height = 10

local Game = {}

local entities = nil

function Game:init()
    local red_team = { id = Teams.HOME, color = Color.RED }
    local blue_team = { id = Teams.AWAY, color = Color.BLUE }
    local score_board = { home_team = 0, away_team = 0, render = { type = "score_board"} }
    entities = {
        Area:new(center_x-line_width, 0, line_width, screen_height, Color.DARK_RED),
        Player:new(
          center_x+player_width*2,
          center_y-player_width/2,
          red_team),
        Player:new(
          center_x+player_width*6,
          center_y-player_width/2,
          red_team),
        -- Player:new(screen_width * 0.8, 500, red_team),
        Player:new(
          center_x-player_width*3,
          center_y-player_width/2,
          blue_team),
        Player:new(
          center_x-player_width*7,
          center_y-player_width/2,
          blue_team),
        -- Player:new(screen_width * 0.1, 200, blue_team),
        -- Player:new(screen_width * 0.1, 100, blue_team),
        Wall:new(0, 0, screen_width, wall_thickness),
        Wall:new(0, 0, wall_thickness, screen_height),
        Wall:new(screen_width - wall_thickness, 0, wall_thickness, screen_height),
        Wall:new(0, screen_height - wall_thickness, screen_width, screen_height),
        Goal:new(home_goal_position, goal_width, goal_height, red_team),
        -- Goal Posts
        Wall:new(home_goal_position.x, home_goal_position.y, goal_width, post_thickness),
        Wall:new(home_goal_position.x, home_goal_position.y, post_thickness, goal_height),
        Wall:new(
          home_goal_position.x,
          home_goal_position.y+goal_height-post_thickness,
          goal_width,
          post_thickness
        ),
        -- Away Team Goal
        Goal:new(away_goal_position, goal_width, goal_height, blue_team),
        -- Goal Posts
        Wall:new(away_goal_position.x, away_goal_position.y, goal_width, post_thickness),
        Wall:new(away_goal_position.x+goal_width, away_goal_position.y, post_thickness, goal_height),
        Wall:new(
          away_goal_position.x,
          away_goal_position.y+goal_height-post_thickness,
          goal_width,
          post_thickness
        ),
        Puck:new(center_x-(puck_width/2), center_y-(puck_height/2), puck_width, puck_height),
        score_board
    }
    for i = 1, #entities do
        entities[i].id = i
    end

    interactive_system = InteractiveSystem:new(entities)
    select_system = SelectSystem:new(red_team, entities)
    EffectsSystem:init(entities)
    AISystem:init(entities)
    ScoringSystem:init(score_board)
end

function Game:update(dt)
    EffectsSystem:handle(dt)
    InputSystem:handle("UNUSED", entities)
    AISystem:handle(dt)
    CollisionSystem:handle(dt, entities)
    PhysicsSystem:handle(dt, entities)
end

function Game:draw()
    RenderSystem:handle(entities)
    AISystem:debug()
end

return Game
