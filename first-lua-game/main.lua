local color = require('color')
local Node = require('node')
local Player = require('player')
local Players = require('players')
local Goal = require('goal')
local Puck = require('puck')
local InputComponent = require('input_component')
local globals = require('globals')
local area = require('area')

local screenWidth, screenHeight = love.window.getMode()
local score = 0
local selected = 1

function checkWallCollision(a)
	return a.x < 0 or a.y < 0 or a.x > screenWidth or a.y > screenHeight
end

function love.load()
		local goal_height = 80
		local goal_width = 40

		players = Players:new({
			Player:new(100, 100, InputComponent:new(globals.InputMap)),
			Player:new(400, 100, InputComponent:new(globals.InputMap))
		})
		
		goal = Goal:new(
			-1,
			150,
			(screenHeight / 2) - (goal_height/2),
			goal_width,
			goal_height
		)
    puck = Puck:new(300, 300)
end

function love.keypressed(key)
		if key == 'k' then
			switch_player(selected + 1)
		end
end

function love.update(dt)
		if love.keyboard.isDown('r') then
			score = 0 
			love.load()
		end

		players:update(dt)
    puck:update(dt)
		puck:bounce(0, 0, screenWidth, screenHeight)

		players:collision(puck)

		if goal:collision(dt, puck) then
			score = score + 1
		end
end

function love.draw()
	goal:draw()
	players:draw()
	puck:draw()

	love.graphics.print("Score: " .. score, 10, screenHeight - 40)
	love.graphics.print("vx: " .. puck.vx .. ", vy: " .. puck.vy .. ", speed: " .. puck.speed, 10, screenHeight - 120)
end

