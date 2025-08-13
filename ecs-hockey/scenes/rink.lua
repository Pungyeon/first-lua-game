local love = require("love")
local Player = require("scripts/entities/player")
local Puck = require("scripts/entities/puck")
local Wall = require("scripts/entities/wall")
local Goal = require("scripts/entities/goal")
local Area = require("scripts/entities/area")
local Circle = require("scripts/entities/circle")
local RenderSystem = require("scripts/systems/render")
local InputSystem = require("scripts/systems/input")
local PhysicsSystem = require("scripts/systems/physics")
local CollisionSystem = require("scripts/systems/collision")
local Color = require("scripts/types/color")
local Teams = require("scripts/types/teams")
local InteractiveSystem = require("scripts/systems/interactive")
local EffectsSystem = require("scripts/systems/effects")
local SelectSystem = require("scripts/systems/select")
local AISystem = require("scripts/systems/ai")
local ScoringSystem = require("scripts/systems/scoring")
local ResetSystem = require("scripts/systems/reset")
local LineCollisionSystem = require("scripts/systems/line_collision_debug")
local Vector = require("scripts/types/vector")

local screen_width, screen_height = love.window.getMode()
local wall_thickness = 10

local goal_height = 75
local goal_width = 60
local home_goal_position = Vector:new(60, (screen_height / 2) - (goal_height / 2))
local post_thickness = 10
local away_goal_position = Vector:new(screen_width - 60 - goal_width, (screen_height / 2) - (goal_height / 2))
local line_width = 5
local center_y = screen_height / 2
local center_x = screen_width / 2
local player_width = 30
local puck_width = 10
local puck_height = 10

local center_circle_radius = 100

local Rink = {}

local entities = nil

function Rink:init()
	local red_team = { id = Teams.HOME, color = Color.RED }
	local blue_team = { id = Teams.AWAY, color = Color.BLUE }
	local score_board = { home_team = 0, away_team = 0, render = { type = "score_board" }, color = Color.GRAY }
	entities = {
		-- Rink
		Area:new(0, 0, screen_width, screen_height, Color.WHITE),
		Area:new(center_x - line_width, 0, line_width, screen_height, Color.DARK_RED),
		Area:new(home_goal_position.x + goal_width - line_width, 0, line_width, screen_height, Color.DARK_RED),
		Area:new(away_goal_position.x, 0, line_width, screen_height, Color.DARK_RED),
		Area:new(screen_width * 0.3, 0, line_width, screen_height, Color.DARK_BLUE),
		Area:new(screen_width * 0.7, 0, line_width, screen_height, Color.DARK_BLUE),
		Circle:new( -- center circle
      "line",
      center_x,
      center_y,
      center_circle_radius,
      Color.DARK_RED
    ),
		Circle:new(
			"fill",
			home_goal_position.x+goal_width,
			center_y,
			(goal_width/2),
			Color.LIGHT_BLUE
		),
		Circle:new(
			"fill",
			away_goal_position.x,
			center_y,
			(goal_width/2),
			Color.LIGHT_BLUE
		),
		Wall:new(0, 0, screen_width, wall_thickness),
		Wall:new(0, 0, wall_thickness, screen_height),
		Wall:new(screen_width - wall_thickness, 0, wall_thickness, screen_height),
		Wall:new(0, screen_height - wall_thickness, screen_width, screen_height),
		-- Game Objects
		Player:new(center_x + player_width * 2, center_y - player_width / 2, red_team),
		Goal:new(home_goal_position, goal_width, goal_height, red_team),
		-- Goal Posts
		Wall:new(home_goal_position.x, home_goal_position.y, goal_width, post_thickness), -- top post
		Wall:new(home_goal_position.x, home_goal_position.y, post_thickness, goal_height, 0.1), -- back post
		Wall:new( -- bottom post
			home_goal_position.x,
			home_goal_position.y + goal_height - post_thickness,
			goal_width,
			post_thickness
		),
		-- Away Team Goal
		Goal:new(away_goal_position, goal_width, goal_height, blue_team),
		-- Goal Posts
		Wall:new(away_goal_position.x, away_goal_position.y, goal_width, post_thickness),
		Wall:new(away_goal_position.x + goal_width, away_goal_position.y, post_thickness, goal_height, 0.1),
		Wall:new(away_goal_position.x, away_goal_position.y + goal_height - post_thickness, goal_width, post_thickness),
		Puck:new(center_x - (puck_width / 2), center_y - (puck_height / 2), puck_width, puck_height),
		score_board,
	}
	for i = 1, #entities do
		entities[i].id = i
	end

	local interactive_system = InteractiveSystem:new(entities)
	local select_system = SelectSystem:new(red_team, entities)
	EffectsSystem:init(entities)
	AISystem:init(entities)
	ScoringSystem:init(score_board)
	ResetSystem:init(entities)
	LineCollisionSystem:init(entities)
end

function Rink:update(dt)
	ScoringSystem:handle(dt)
	EffectsSystem:handle(dt)
	InputSystem:handle("UNUSED", entities)
	AISystem:handle(dt)
	CollisionSystem:handle(dt, entities)
	PhysicsSystem:handle(dt, entities)
	ResetSystem:handle(dt)
end

function Rink:draw()
	RenderSystem:handle(entities)
	-- AISystem:debug()
	-- LineCollisionSystem:draw()
end

return Rink
