local love = require("love")
local Player = require("scripts/entities/player")
local Puck = require("scripts/entities/puck")
local Wall = require("scripts/entities/wall")
local Goal = require("scripts/entities/goal")
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
local RinkEntity = require("scripts/entities/rink")
local GoalieEntity = require("scripts/entities/goalie")

local screen_width, screen_height = love.window.getMode()

local goal_line_home = screen_width * 0.1
local goal_line_away = screen_width * 0.9
local goal_height = screen_width / 12
local goal_width = screen_width / 25
local home_goal_position = Vector:new(goal_line_home - goal_width, (screen_height / 2) - (goal_height / 2))
local post_thickness = 10
local away_goal_position = Vector:new(goal_line_away, (screen_height / 2) - (goal_height / 2))
local center_y = screen_height / 2
local center_x = screen_width / 2
local player_width = 30
local puck_width = 10
local puck_height = 10

local Goalie = {}

local entities = nil

function Goalie:init()
	local red_team = { id = Teams.HOME, color = Color.RED }
	local blue_team = { id = Teams.AWAY, color = Color.BLUE }
	local score_board = { home_team = 0, away_team = 0, render = { type = "score_board" }, color = Color.GRAY }
	entities = RinkEntity:new({
		-- Goalie
		-- Game Objects
		Player:new(center_x + player_width * 2, center_y - player_width / 2, red_team),
		Player:new(center_x - player_width * 10, center_y - player_width / 2, blue_team),
    GoalieEntity:new(home_goal_position.x + goal_width, center_y - player_width / 2, blue_team),
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
		Wall:new(
			away_goal_position.x + goal_width - post_thickness,
			away_goal_position.y,
			post_thickness,
			goal_height,
			0.1
		),
		Wall:new(away_goal_position.x, away_goal_position.y + goal_height - post_thickness, goal_width, post_thickness),
		Puck:new(center_x - (puck_width / 2), center_y - (puck_height / 2), puck_width, puck_height),
		score_board,
	})
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

function Goalie:update(dt)
	ScoringSystem:handle(dt)
	EffectsSystem:handle(dt)
	InputSystem:handle("UNUSED", entities)
	AISystem:handle(dt)
	CollisionSystem:handle(dt, entities)
	PhysicsSystem:handle(dt, entities)
	ResetSystem:handle(dt)
end

function Goalie:draw()
	RenderSystem:handle(entities)
	-- AISystem:debug()
	-- LineCollisionSystem:draw()
end

return Goalie
