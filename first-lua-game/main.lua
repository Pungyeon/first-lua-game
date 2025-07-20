local color = require('color')
local Node = require('node')
local Player = require('player')
local Goalie = require('goalie')
local Players = require('players')
local Goal = require('goal')
local Puck = require('puck')
local InputComponent = require('input_component')
local globals = require('globals')
local area = require('area')

local screenWidth, screenHeight = love.window.getMode()
local score = 0
local selected = 1

local goal_height = 140
local goal_width = 40
local goal_center = (screenHeight / 2) - (goal_height/2)


function checkWallCollision(a)
	return a.x < 0 or a.y < 0 or a.x > screenWidth or a.y > screenHeight
end

function love.load()

		players = Players:new({
			Player:new(100, 100, color.RED, InputComponent:new(globals.InputMap)),
			Player:new(400, 100, color.RED, InputComponent:new(globals.InputMap))
		})

		goalie = Goalie:new(210, 380, color.GREEN, {})
		
		goal = Goal:new(-1, 150, goal_center, goal_width, goal_height)
    puck = Puck:new(300, 300)
end

function love.keypressed(key)
		if key == 'k' then
			players:switch_next()
		elseif key == 'r' then
			score = 0
			love.load()
		end
end

function love.update(dt)
		-- Handle Input here to ensure that inputs are handled before updating
 		-- this makes handling collisions and movement cancellation much easier
		players:handle_input()
		
		-- TODO : maybe change this method name to handle_input ? 
		goalie:move_towards(dt, puck)

		players:collision(puck)

		if area.Collision(goalie, puck) then
			goalie:pickup(puck)
		end

		players:foreach(function(i, player)
			player:update(dt)
			if area.Collision(player, goalie) then
				player:rollback(dt)
			end
			if players:internal_collision(i) then
				player:rollback(dt)
			end
		end)
    puck:update(dt)
		puck:bounce(0, 0, screenWidth, screenHeight)




		goalie:update(dt)


		if goal:collision(dt, puck) then
			score = score + 1
		end
end

function love.draw()
	goal:draw()
	players:draw()
	puck:draw()
	goalie:draw()

	love.graphics.print("Score: " .. score, 10, screenHeight - 40)
	love.graphics.print("Goalie" .. goalie.puck_time, 10, screenHeight - 60)
	love.graphics.print("puck_owner: " .. puck:string(), 10, screenHeight - 80)
end

