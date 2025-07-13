local color = require('color')
local Node = require('node')
local Player = require('player')
local Puck = require('puck')
local InputComponent = require('input_component')
local globals = require('globals')

function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end

function love.load()
    player = Player:new(100, 100, InputComponent:new(globals.InputMap))
    puck = Puck:new(300, 300)
end

function love.update(dt)
    player:update(dt)
    puck:update(dt)

		if checkCollision(player, puck) then
			puck.color = color.GREEN
		else 
			puck.color = color.WHITE
		end
end

function love.draw()
    player:draw()
    puck:draw()
end

