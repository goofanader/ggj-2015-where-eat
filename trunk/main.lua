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
   currentTraits = {}
   --get the real dimensions of the screen
   WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()
   --Initialize state variables
   gameState = 0
   turnSelect = 1
   locationSelect = 1
   roommateSelect = 1
   researchSelect = 1
   debugOn = 1
   --Some constants?
   PAUSE_TIME = 6 --seconds

   --loading images
   menuImage = love.graphics.newImage("media/Main_Menu.png")
   foregroundImage = love.graphics.newImage("media/BG_Foreground.png")
   backgroundImage = love.graphics.newImage("media/BG_Background.png")

   -- setup the roommate images
   roommateImages = {}
   -- begin with their actual selves
   roommateImages[1] = {}
   roommateImages[1][1] = {love.graphics.newImage("media/WestDude_1.png"), love.graphics.newImage("media/WestDude_2.png"), love.graphics.newImage("media/WestDude_3.png")}
   roommateImages[1][2] = {love.graphics.newImage("media/WestDudette_1.png"), love.graphics.newImage("media/WestDudette_2.png"), love.graphics.newImage("media/WestDudette_3.png")}
   roommateImages[1][3] = {love.graphics.newImage("media/EastDudette_1.png"), love.graphics.newImage("media/EastDudette_2.png"), love.graphics.newImage("media/EastDudette_3.png")}
   roommateImages[1][4] = {love.graphics.newImage("media/EastDude_1.png"), love.graphics.newImage("media/EastDude_2.png"), love.graphics.newImage("media/EastDude_3.png")}

   -- load the text boxes
   roommateImages[2] = {}
   roommateImages[2][1] = love.graphics.newImage("media/TextBox_WestDude.png")
   roommateImages[2][2] = love.graphics.newImage("media/TextBox_WestDudette.png")
   roommateImages[2][3] = love.graphics.newImage("media/TextBox_EastDudette.png")
   --roommateImages[2][4] = love.graphics.newImage("media/TextBox_EastDude.png")

   -- set the x, y position of the text
   roommateImages[3] = {}
   roommateImages[3][1] = {13, 5}
   roommateImages[3][2] = {48, 18}
   roommateImages[3][3] = {29, 18}

   --set the image scale for the game
   imageScale = WINDOW_WIDTH / backgroundImage:getWidth()

   --loading fonts
   clockFont = love.graphics.newImageFont("media/Clock_Text.png", "1234567890: ")
   defaultFont = love.graphics.setNewFont("media/04B_03__.TTF", 16)

   love.mouse.setCursor(love.mouse.newCursor("media/mouse.png"))

   --remove when we add a picture background
   --Phyl: we should have a background color, it's good for in case we put the picture some place wrong
   love.graphics.setBackgroundColor( 255, 255, 255 )

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
      roommates[1]:draw()
      roommates[4]:draw()

      --draw the foreground
      love.graphics.draw(foregroundImage, 0, 0, 0, imageScale)

      -- draw the foreground roommates
      roommates[2]:draw()
      roommates[3]:draw()

      --draw black "console"
      love.graphics.setColor( 0, 0, 0 )
      love.graphics.rectangle("fill", 0, 53 * imageScale, WINDOW_WIDTH, WINDOW_HEIGHT - (53 * imageScale))

      --draw text
      love.graphics.setColor( 255, 255, 255 )

      if gameState == 1 then --Turn Options
         love.graphics.print("WHAT DO YOU DO NOW?", 1 * imageScale, 54 * imageScale)
         for i, string in ipairs(turnOptions) do
            if turnSelect == i then
               love.graphics.rectangle("fill", 2 * imageScale, (54+2*i) * imageScale, 40 * imageScale, defaultFont:getHeight() )
               love.graphics.setColor( 0, 0, 0 )
            end
            love.graphics.print(i .. ") " .. string, 2 * imageScale, (54+2*i) * imageScale)
            love.graphics.setColor( 255, 255, 255 )
         end

      elseif gameState == 2 then --Restaurant Options
         love.graphics.print("WHERE DO WE EAT NOW?", 1 * imageScale, 54 * imageScale)
         for i=1, 6 do
            if locationSelect == i then
               love.graphics.rectangle("fill", 2 * imageScale, (54+2*i) * imageScale, 40 * imageScale, defaultFont:getHeight() )
               love.graphics.setColor( 0, 0, 0 )
            end
            love.graphics.print(i .. ") " .. locationMasterList[i]:__tostring(), 2 * imageScale, (54+2*i) * imageScale)
            love.graphics.setColor( 255, 255, 255 )
         end

      elseif gameState == 3 then --Roommate Options
         love.graphics.print("WHO DO YOU ASK NOW?", 1 * imageScale, 54 * imageScale)
         for i=1, 4 do
            if roommateSelect == i then
               love.graphics.rectangle("fill", 2 * imageScale, (54+2*i) * imageScale, 40 * imageScale, defaultFont:getHeight() )
               love.graphics.setColor( 0, 0, 0 )
            end
            love.graphics.print(roommates[i].name, 4 * imageScale, (54+2*i) * imageScale)
            love.graphics.setColor( 255, 255, 255 )
         end
      elseif gameState == 4 then --Research Options
         love.graphics.print("WHAT DO YOU RESEARCH NOW?", 1 * imageScale, 54 * imageScale)
         for i, string in ipairs(researchOptions) do
            if researchSelect == i then
               love.graphics.rectangle("fill", 2 * imageScale, (54+2*i) * imageScale, 40 * imageScale, defaultFont:getHeight() )
               love.graphics.setColor( 0, 0, 0 )
            end
            love.graphics.print(i .. ") " .. string, 2 * imageScale, (54+2*i) * imageScale)
            love.graphics.setColor( 255, 255, 255 )
         end
      elseif gameState == 5 then --Results Screen!
         if results then
            love.graphics.print(results, 1 * imageScale, 54 * imageScale)
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

   if gameState == 0 then --Main Menu
   elseif gameState == 1 then --Turn options
   elseif gameState == 2 then --Choose a Restaurant
   elseif gameState == 3 then --Choose a Roommate
   elseif gameState == 4 then --Choose Research
   elseif gameState == 5 then --Show Results
      if resultsTimer then --check if we just started this state
         resultsTimer = false
         startTime = love.timer.getTime( )
         tickTime = startTime
      end
      if (love.timer.getTime( ) - tickTime) >= (PAUSE_TIME/16) then --Increment the clock
         wallClock.time:addMinutes(1)
         tickTime = love.timer.getTime( )
      end
      if (love.timer.getTime( ) - startTime) >= PAUSE_TIME then --Exit this state
         gameState = 1 --go back to start
         roommates[roommateSelect]:stopTalking()
         roommateSelect = 1
      end

   else
      print("ERROR ERROR ERROR")
   end

   wallClock:update(dt)

   for i=1, 4 do
      if roommates[i] then
         roommates[i]:update(dt)
      end
   end
end

function love.keypressed(key)
   if gameState == 0 then
      if key == "return" or key == " " then
         currentTraits = {}
         for i=1, 4 do
            local gender = "girl"
            if i == 1 or i == 4 then
               gender = "boy"
            end
            roommates[i] = Roommate:new(gender, roommateImages[1][i], roommateImages[2][i], roommateImages[3][i], i)
            for i, trait in ipairs(roommates[i].traits) do
               table.insert(currentTraits,trait)
            end

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


            --TODO: play accept sound
         end

      elseif gameState == 2 then
         if key == "up" and locationSelect > 1 then
            locationSelect = locationSelect - 1
         elseif key == "down" and locationSelect < 6 then
            locationSelect = locationSelect + 1
         elseif key == "return" or key == " " then
            --go through all active traits to check for conflicts
            for i, roomy in ipairs(roommates) do
               for j, trait in ipairs(roomy.traits) do
                  --if trait.vegan == 1 and restaurant.vegan == 0
               end
            end

            locationSelect = 1
            gameState = 5 --go to results
            resultsTimer = true
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
            results = "You ask " .. roommates[roommateSelect].name .. " for a suggestion. " .. roommates[roommateSelect]:getPronoun(true) .. " is pretty much useless."
            roommates[roommateSelect]:startTalking("I'm feelin' pizza.")
            gameState = 5 --go to results
            resultsTimer = true
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
            results = "You spend 15 minutes researching the " .. "Menus" .. " of the restaurants\nand somehow manage to figure out when they all close."
            researchSelect = 1
            gameState = 5 --go to results
            resultsTimer = true
            --TODO: play accept sound
         elseif key == "backspace" then
            researchSelect = 1
            gameState = 1
            --TODO: play back sound
         end

      elseif gameState == 5 then
         --doo dee doo
         --let them skip it?
      end     
   end

   if key == "q" or key == "escape" then
      love.event.quit()
   end
   if key == "d" then
      debugOn = -debugOn
   end
   if key == "r" then
      currentTraits = {}
      for i=1, 4 do
         local gender = "girl"
         if i == 1 or i == 4 then
            gender = "boy"
         end
         roommates[i] = Roommate:new(gender, roommateImages[1][i], roommateImages[2][i], roommateImages[3][i], i)
         for i, trait in ipairs(roommates[i].traits) do
            table.insert(currentTraits,trait)
         end
      end
   end
end
