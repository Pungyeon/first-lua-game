local love = require("love")
local Wall = require("scripts/entities/wall")
local Area = require("scripts/entities/area")
local Circle = require("scripts/entities/circle")
local Color = require("scripts/types/color")
local Vector = require("scripts/types/vector")

local screen_width, screen_height = love.window.getMode()
local wall_thickness = 10

local goal_line_home = screen_width*0.1
local goal_line_away = screen_width*0.9
local goal_height = screen_width / 12
local goal_width = screen_width / 25
local home_goal_position = Vector:new(goal_line_home-goal_width, (screen_height / 2) - (goal_height / 2))
local away_goal_position = Vector:new(goal_line_away, (screen_height / 2) - (goal_height / 2))
local line_width = 5
local center_y = screen_height / 2
local center_x = screen_width / 2

local center_circle_radius = screen_height/8

local Rink = {}

function Rink:new(entities)
  local rink_entities = {
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
			goal_height/2,
			Color.LIGHT_BLUE
		),
		Circle:new(
			"fill",
			away_goal_position.x,
			center_y,
			goal_height/2,
			Color.LIGHT_BLUE
		),
    Circle:new(
      "line",
      screen_width * 0.2,
      screen_height * 0.2,
      center_circle_radius / 2,
      Color.DARK_RED
    ),
    Circle:new(
      "fill",
      screen_width * 0.2,
      screen_height * 0.2,
      5,
      Color.DARK_RED
    ),
    Circle:new(
      "line",
      screen_width * 0.8,
      screen_height * 0.8,
      center_circle_radius / 2,
      Color.DARK_RED
    ),
    Circle:new(
      "fill",
      screen_width * 0.8,
      screen_height * 0.8,
      5,
      Color.DARK_RED
    ),
    Circle:new(
      "line",
      screen_width * 0.2,
      screen_height * 0.8,
      center_circle_radius / 2,
      Color.DARK_RED
    ),
    Circle:new(
      "fill",
      screen_width * 0.2,
      screen_height * 0.8,
      5,
      Color.DARK_RED
    ),
    Circle:new(
      "line",
      screen_width * 0.8,
      screen_height * 0.2,
      center_circle_radius / 2,
      Color.DARK_RED
    ),
    Circle:new(
      "fill",
      screen_width * 0.8,
      screen_height * 0.2,
      5,
      Color.DARK_RED
    ),
		Wall:new(0, 0, screen_width, wall_thickness),
		Wall:new(0, 0, wall_thickness, screen_height),
		Wall:new(screen_width - wall_thickness, 0, wall_thickness, screen_height),
		Wall:new(0, screen_height - wall_thickness, screen_width, screen_height),
  }

  for _, entity in ipairs(entities) do
    table.insert(rink_entities, entity)
  end

  return rink_entities
end

return Rink
