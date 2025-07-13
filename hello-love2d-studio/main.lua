local lg = love.graphics
local screenWidth, screenHeight = love.window.getMode()

function love.load()

end

function love.update(dt)
	-- This is where the movement and environment logic should go
end


function love.draw()
  bg.draw()
  local left =40
  local top = 200
  if screenWidth < 500 or screenHeight < 500 then
     left = 20
  end
  lg.print(printedText, left, top)
end

function love.resize(w, h)
   print("love.resize")
   lg.clear()

   lg.present()
end


