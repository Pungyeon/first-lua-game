local lg = love.graphics
local screenWidth, screenHeight = love.window.getMode()

function love.load()

end

function love.update(dt)
	-- This is where the movement and environment logic should go
	if love.keyboard.isDown('w') then
	end 

end


function love.draw()
  -- This is where we draw all the elements that require drawing
	lg.rectangle("fill", 50, 50, 30, 30)
end

function love.resize(w, h)
   print("love.resize")
   lg.clear()

   lg.present()
end


