local color = require('color')
local Node = require('node')
local Player = require('player')
local Goal = require('goal')
local Puck = require('puck')
local InputComponent = require('input_component')
local globals = require('globals')

local screenWidth, screenHeight = love.window.getMode()
local score = 0

function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end

function checkWallCollision(a)
	return a.x < 0 or a.y < 0 or a.x > screenWidth or a.y > screenHeight
end

function love.load()
		local goal_height = 80
		local goal_width = 20

    player = Player:new(100, 100, InputComponent:new(globals.InputMap))
		goal = Goal:new(
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

		if checkCollision(player, puck) then
			player:pickup(puck)
		end

		if checkCollision(puck, goal) then 
			score = score + 1
		end
end

function love.draw()
	player:draw()
	puck:draw()
	goal:draw()

	love.graphics.print("Score: " .. score, 10, screenHeight - 40)
end

