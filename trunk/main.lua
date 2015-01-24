--What Do We Eat For Dinner?
--A game by Andrew & Phyllis

require 'classes/wallClock'

function love.load()
   --get the real dimensions of the screen
   WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()
   
   love.mouse.setCursor(love.mouse.newCursor("media/mouse.png"))
   love.graphics.setDefaultFilter("nearest","nearest")
   defaultFont = love.graphics.setNewFont("media/04B_03__.TTF", 16 * WINDOW_WIDTH / 1280)
   
   --loading clock font
   clockFont = love.graphics.newImageFont("media/Clock_Text.png", "1234567890: ")
   
   --loading images
   foregroundImage = love.graphics.newImage("media/BG_Foreground.png")
   backgroundImage = love.graphics.newImage("media/BG_Background.png")
   
   --remove when we add a picture background
   --Phyl: we should have a background color, it's good for in case we put the picture some place wrong
   love.graphics.setBackgroundColor( 255, 255, 255 )
   
   gameState = 1
   turnSelect = 1
   restaurantSelect = 1
   roommateSelect = 1
   researchSelect = 1
   
   wallClock = WallClock:new(Time:new(6, 0))
end

function love.draw()
   --draw the background
   love.graphics.setColor(255, 255, 255)
   love.graphics.draw(backgroundImage, 0, 0, 0, WINDOW_WIDTH / backgroundImage:getWidth(), WINDOW_HEIGHT / backgroundImage:getHeight())
   
   --draw the clock's current time
   wallClock:draw()
   
   --draw the roommates
   
   --draw the foreground
   love.graphics.draw(foregroundImage, 0, 0, 0, WINDOW_WIDTH / foregroundImage:getWidth(), WINDOW_HEIGHT / foregroundImage:getHeight())
   
   --draw black "console"
   love.graphics.setColor( 0, 0, 0 )
   love.graphics.rectangle("fill", 0, 530 * WINDOW_HEIGHT / 720, WINDOW_WIDTH, WINDOW_HEIGHT - (530 * WINDOW_HEIGHT / 720))
   
   --draw text
   love.graphics.setColor( 255, 255, 255 )
   love.graphics.print("MENU", 50 * WINDOW_WIDTH / 1280, 540 * WINDOW_HEIGHT / 720) --Screen size is 1280x720
   
end

function love.update(dt)
   
   --Finite State Machine!
   if gameState == 1 then
      --Turn options
   elseif gameState == 2 then
      --Choose a Restaurant
   elseif gameState == 3 then
      --Choose a Roommate
   elseif gameState ==4 then
      --Choose Research
   else
      --throw error
   end
   
   wallClock:update(dt)
end

function love.keypressed(key)
   if gameState > 0 then
      --TODO: play boop sound
      if gameState == 1 then
         if key == "up" and turnSelect > 1 then
            turnSelect = turnSelect - 1
            print(turnSelect)
         elseif key == "down" and turnSelect < 3 then
            turnSelect = turnSelect + 1
            print(turnSelect)
         elseif key == "enter" then
            gameState = turnSelect + 1 --selects between next 3 gamestates
            --TODO: play accept sound
         end
      elseif gameState == 2 then
         if key == "up" and restaurantSelect > 1 then
            restaurantSelect = restaurantSelect - 1
            print("up")
         elseif key == "down" and restaurantSelect < 4 then
            restaurantSelect = restaurantSelect + 1
            print("down")
         end
         
      elseif gameState == 3 then
         if key == "up" and roommateSelect > 1 then
            roommateSelect = roommateSelect - 1
            print("up")
         elseif key == "down" and roommateSelect < 4 then
            roommateSelect = roommateSelect + 1
            print("down")
         end
      elseif gameState == 4 then
         if key == "up" and researchSelect > 1 then
            researchSelect = researchSelect - 1
            print("up")
         elseif key == "down" and researchSelect < 2 then
            researchSelect = researchSelect + 1
            print("down")
         end
      end
   end
end
      