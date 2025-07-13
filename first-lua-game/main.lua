local lg = love.graphics
local screenWidth, screenHeight = love.window.getMode()

local player_x = 50
local player_y = 50
local player_width = 30
local player_height = 30

function love.load()

end

function love.update(dt)
	if love.keyboard.isDown('w') then
		player_y = player_y - 1
	end 

end


function love.draw()
  -- This is where we draw all the elements that require drawing
	lg.rectangle("fill", player_x, player_y, player_width, player_height)
end

function love.resize(w, h)
   print("love.resize")
   lg.clear()

   lg.present()
end


