local color = require('color')
local Node = require('node')
local Player = require('player')
local Goal = require('goal')
local Puck = require('puck')
local InputComponent = require('input_component')
local globals = require('globals')
local area = require('area')

local screenWidth, screenHeight = love.window.getMode()
local score = 0

function checkWallCollision(a)
	return a.x < 0 or a.y < 0 or a.x > screenWidth or a.y > screenHeight
end

function love.load()
		local goal_height = 80
		local goal_width = 40

    player = Player:new(100, 100, InputComponent:new(globals.InputMap))
		goal = Goal:new(
			-1,
			150,
			(screenHeight / 2) - (goal_height/2),
			goal_width,
			goal_height
		)
    puck = Puck:new(300, 300)
end

function love.update(dt)
		if love.keyboard.isDown('r') then
			love.load()
		end

    player:update(dt)
    puck:update(dt)
		puck:bounce(0, 0, screenWidth, screenHeight)

		if area.Collision(player, puck) then 
			player:pickup(puck)
		end

		if goal:collision(dt, puck) then
			score = score + 1
		end
end

function love.draw()
	score = 0
	goal:draw()
	player:draw()
	puck:draw()


	love.graphics.print("Score: " .. score, 10, screenHeight - 40)
	love.graphics.print("vx: " .. player.vx .. ", vy: " .. player.vy .. ", speed: " .. player.speed, 10, screenHeight - 80)
	love.graphics.print("vx: " .. puck.vx .. ", vy: " .. puck.vy .. ", speed: " .. puck.speed, 10, screenHeight - 120)
end

