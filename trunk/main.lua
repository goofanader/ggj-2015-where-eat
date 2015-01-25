--What Do We Eat For Dinner?
--A game by Andrew & Phyllis

require 'classes/data'
require 'classes/wallClock'
require 'classes/roommate'
require ("socket")

function love.load()
   love.graphics.setDefaultFilter("nearest","nearest")
   --load the data
   buildDataTables()
   roommates = {}
   --get the real dimensions of the screen
   WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()

   --loading images
   menuImage = love.graphics.newImage("media/Main_Menu.png")
   foregroundImage = love.graphics.newImage("media/BG_Foreground.png")
   backgroundImage = love.graphics.newImage("media/BG_Background.png")
   roommate1Image = love.graphics.newImage("media/WestDude.png")
   roommate2Image = love.graphics.newImage("media/WestDudette.png")
   roommate3Image = love.graphics.newImage("media/EastDudette.png")
   --roommate4Image = love.graphics.newImage("media/EastDude.png")

   --set the image scale for the game
   imageScale = WINDOW_WIDTH / backgroundImage:getWidth()

   --loading fonts
   clockFont = love.graphics.newImageFont("media/Clock_Text.png", "1234567890: ")
   defaultFont = love.graphics.setNewFont("media/04B_03__.TTF", 16)

   love.mouse.setCursor(love.mouse.newCursor("media/mouse.png"))

   --remove when we add a picture background
   --Phyl: we should have a background color, it's good for in case we put the picture some place wrong
   love.graphics.setBackgroundColor( 255, 255, 255 )

   gameState = 0
   turnSelect = 1
   locationSelect = 1
   roommateSelect = 1
   researchSelect = 1
   debugOn = 1

   wallClock = WallClock:new(Time:new(6, 0))
end

function love.draw()
   --draw the background
   love.graphics.setColor(255, 255, 255)
   if gameState == 0 then
      love.graphics.draw(menuImage, 0, 0, 0, imageScale)
   else
      love.graphics.draw(backgroundImage, 0, 0, 0, imageScale)

      --draw the clock's current time
      wallClock:draw()

      --draw the roommates in between foreground and background
      love.graphics.draw(roommate1Image, 0,0,0, imageScale)
      
      
      --draw the foreground
      love.graphics.draw(foregroundImage, 0, 0, 0, imageScale)
      
      -- draw the foreground roommates
      love.graphics.draw(roommate2Image, 0,0,0, imageScale)
      love.graphics.draw(roommate3Image, 0,0,0, imageScale)

      --draw black "console"
      love.graphics.setColor( 0, 0, 0 )
      love.graphics.rectangle("fill", 0, 53 * imageScale, WINDOW_WIDTH, WINDOW_HEIGHT - (53 * imageScale))

      --draw text
      love.graphics.setColor( 255, 255, 255 )
      
      if gameState == 1 then --Turn Options
         love.graphics.print("WHAT DO YOU DO NOW?", 1 * imageScale, 54 * imageScale)
         for i, string in ipairs(turnOptions) do
            if turnSelect == i then
               love.graphics.rectangle("fill", 2 * imageScale, (54+2*i) * imageScale, 50 * imageScale, 1.5 * imageScale )
               love.graphics.setColor( 0, 0, 0 )
            end
            love.graphics.print(i .. ") " .. string, 2 * imageScale, (54+2*i) * imageScale)
            love.graphics.setColor( 255, 255, 255 )
         end
         
      elseif gameState == 2 then --Restaurant Options
         love.graphics.print("WHERE DO WE EAT NOW?", 1 * imageScale, 54 * imageScale)
         for i=1, 6 do
            if locationSelect == i then
               love.graphics.rectangle("fill", 2 * imageScale, (54+2*i) * imageScale, 50 * imageScale, 1.5 * imageScale )
               love.graphics.setColor( 0, 0, 0 )
            end
            love.graphics.print(i .. ") " .. locationMasterList[i]:__tostring(), 2 * imageScale, (54+2*i) * imageScale)
            love.graphics.setColor( 255, 255, 255 )
         end
         
      elseif gameState == 3 then --Roommate Options
         love.graphics.print("WHO DO YOU ASK NOW?", 1 * imageScale, 54 * imageScale)
         for i=1, 4 do
            if roommateSelect == i then
               love.graphics.rectangle("fill", 2 * imageScale, (54+2*i) * imageScale, 50 * imageScale, 1.5 * imageScale )
               love.graphics.setColor( 0, 0, 0 )
            end
            love.graphics.print(roommates[i].name, 4 * imageScale, (54+2*i) * imageScale)
            love.graphics.setColor( 255, 255, 255 )
         end
      elseif gameState == 4 then --Research Options
         love.graphics.print("WHAT DO YOU RESEARCH NOW?", 1 * imageScale, 54 * imageScale)
         for i, string in ipairs(researchOptions) do
            if researchSelect == i then
               love.graphics.rectangle("fill", 2 * imageScale, (54+2*i) * imageScale, 50 * imageScale, 1.5 * imageScale )
               love.graphics.setColor( 0, 0, 0 )
            end
            love.graphics.print(i .. ") " .. string, 2 * imageScale, (54+2*i) * imageScale)
            love.graphics.setColor( 255, 255, 255 )
         end
      end
      
      if debugOn == 1 then
         love.graphics.setColor( 0, 255, 0 )
         for i=1, 4 do
            love.graphics.print(roommates[i]:__tostring(), (12+i) * imageScale, (17+5*i) * imageScale)
         end
         love.graphics.setColor(255, 255, 255)
      end
      
   end
end

function love.update(dt)

   --Finite State Machine!
   if gameState == 0 then
      --Main Menu
   elseif gameState == 1 then
      --Turn options
   elseif gameState == 2 then
      --Choose a Restaurant
   elseif gameState == 3 then
      --Choose a Roommate
   elseif gameState ==4 then
      --Choose Research
   else
      print("ERROR ERROR ERROR")
   end

   wallClock:update(dt)
end

function love.keypressed(key)
   if gameState == 0 then
      if key == "return" or key == " " then
         for i=1, 4 do
            roommates[i] = Roommate:new(i)
         end
         
         --TODO: play start sound
         gameState = 1
      end
   else
      --TODO: play boop sound
      if gameState == 1 then
         if key == "up" and turnSelect > 1 then
            turnSelect = turnSelect - 1
         elseif key == "down" and turnSelect < 3 then
            turnSelect = turnSelect + 1
         elseif key == "return" or key == " " then
            gameState = turnSelect + 1 --selects between next 3 gamestates
            turnSelect = 1
            
            for i=1, 4 do
               roommates[i] = Roommate:new(i)
            end
            --TODO: play accept sound
         end
         
      elseif gameState == 2 then
         if key == "up" and locationSelect > 1 then
            locationSelect = locationSelect - 1
         elseif key == "down" and locationSelect < 6 then
            locationSelect = locationSelect + 1
         elseif key == "return" or key == " " then
            locationSelect = 1
            gameState = 1 --go back to start
            wallClock.time:addMinutes(15)
            --TODO: play accept sound
         elseif key == "backspace" then
            locationSelect = 1
            gameState = 1
            --TODO: play back sound
         end
         
      elseif gameState == 3 then
         if key == "up" and roommateSelect > 1 then
            roommateSelect = roommateSelect - 1
         elseif key == "down" and roommateSelect < 4 then
            roommateSelect = roommateSelect + 1
         elseif key == "return" or key == " " then
            roommateSelect = 1
            gameState = 1 --go back to start
            wallClock.time:addMinutes(15)
            --TODO: play accept sound
         elseif key == "backspace" then
            roommateSelect = 1
            gameState = 1
            --TODO: play back sound
         end
         
      elseif gameState == 4 then
         if key == "up" and researchSelect > 1 then
            researchSelect = researchSelect - 1
         elseif key == "down" and researchSelect < 2 then
            researchSelect = researchSelect + 1
         elseif key == "return" or key == " " then
            researchSelect = 1
            gameState = 1 --go back to start
            wallClock.time:addMinutes(15)
            --TODO: play accept sound
         elseif key == "backspace" then
            researchSelect = 1
            gameState = 1
            --TODO: play back sound
         end
      end
   end

   if key == "q" or key == "escape" then
      love.event.quit()
   end
   if key == "d" then
      debugOn = -debugOn
   end

end
