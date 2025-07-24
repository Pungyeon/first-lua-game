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
local goal_center = (screenHeight / 2) - (goal_height / 2)


function checkWallCollision(a)
    return a.x < 0 or a.y < 0 or a.x > screenWidth or a.y > screenHeight
end

function love.load()
    puck = Puck:new(screenWidth / 2, screenHeight / 2)

    home_team = Players:new({
        Player:new(
            screenWidth / 2 + 100,
            screenHeight / 2 + 100,
            color.RED,
            InputComponent:new(globals.InputMap)
        ),
        Player:new(
            screenWidth / 2 + 100,
            screenHeight / 2 - 100,
            color.RED,
            InputComponent:new(globals.InputMap)
        )
    })

    away_team = Players:new({
        Player:new(
            screenWidth / 2 - 100,
            screenHeight / 2 + 100,
            color.GREEN,
            nil
        ),
        Player:new(
            screenWidth / 2 - 100,
            screenHeight / 2 - 100,
            color.GREEN,
            nil
        )
    })

    goalie = Goalie:new(210, 380, color.GREEN, {})

    goal = Goal:new(-1, 150, goal_center, goal_width, goal_height)
end

function love.keypressed(key)
    if key == 'k' then
        home_team:switch_next()
    elseif key == 'r' then
        score = 0
        love.load()
    end
end

function love.update(dt)
    -- Handle Input here to ensure that inputs are handled before updating
    -- this makes handling collisions and movement cancellation much easier
    -- away_team:handle_input(puck, goal)
    home_team:handle_input(puck, goal)

    -- TODO : maybe change this method name to handle_input ?
    goalie:move_towards(dt, puck)

    home_team:pickup_collision(puck)
    away_team:pickup_collision(puck)

    if area.Collision(goalie, puck) then
        goalie:pickup(puck)
    end

    -- BACKEND TODO
    -- TODO : Add enemy players
    -- TODO : Add AI movement for team mates and enemy players
    -- TODO : Add goal for player team
    -- TODO : Improve goalie AI
    -- TODO : Implement scoring system + reset.
    -- TODO : Implement tackling (enemy) players
    --

    -- FRONTEND TODO
    -- TODO : Create some graphics !
    away_team:foreach(function(i, player)
        player:update(dt)
        if area.Collision(player, goal) then
            player:rollback(dt)
        end
        if area.Collision(player, goalie) then
            player:rollback(dt)
        end
        if away_team:internal_collision(i) then
            player:rollback(dt)
        end
        if away_team:external_collision(player, home_team.players) then
            player:rollback(dt)
        end
    end)

    home_team:foreach(function(i, player)
        player:update(dt)
        if area.Collision(player, goal) then
            player:rollback(dt)
        end
        if area.Collision(player, goalie) then
            player:rollback(dt)
        end
        if home_team:internal_collision(i) then
            player:rollback(dt)
        end
        if home_team:external_collision(player, away_team.players) then
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
    away_team:draw()
    home_team:draw()
    puck:draw()
    goalie:draw()

    love.graphics.print("Score: " .. score, 10, screenHeight - 40)
    love.graphics.print("Goalie" .. goalie.puck_time, 10, screenHeight - 60)
    love.graphics.print("puck_owner: " .. puck:string(), 10, screenHeight - 80)
end
