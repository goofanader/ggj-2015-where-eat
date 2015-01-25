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
   --Initialize variables
   gameState = 0
   turnSelect = 1
   locationSelect = 1
   pageSelect = 1
   roommateSelect = 1
   researchSelect = 1
   debugOn = 0
   trollFlag = 0
   trollTarget = nil
   troll = nil
   speaker = nil
   hoursFound = false
   costsFound = false
   menusFound = false
   delivFound = false
   --Some constants?
   PAUSE_TIME = 6 --seconds
   LOCATIONS_PER_PAGE = 6
   SELECTION_WIDTH = 30

   --loading images
   menuImage = love.graphics.newImage("media/Title_Screen.png")
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
   roommateImages[2][4] = love.graphics.newImage("media/TextBox_EastDude.png")

   -- set the x, y position of the text
   roommateImages[3] = {}
   roommateImages[3][1] = {13, 5}
   roommateImages[3][2] = {48, 18}
   roommateImages[3][3] = {29, 18}
   roommateImages[3][4] = {53, 42}
   
   -- load the songs
   songs = {}
   table.insert(songs, love.audio.newSource("media/bensound-theelevatorbossanova.mp3"))
   table.insert(songs, love.audio.newSource("media/bensound-thejazzpiano.mp3"))
   
   -- load the sounds
   sfx = {["select"] = love.audio.newSource("media/Select.wav", "static"),
      ["back"] = love.audio.newSource("media/Back.wav", "static")}

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
   
   --play a random song
   math.randomseed(socket.gettime())
   math.random()
   math.random()
   
   local songIndex = 2--math.random(1, table.maxn(songs))
   songs[songIndex]:setLooping(true)
   songs[songIndex]:setVolume(1)
   songs[songIndex]:play()
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

      --draw the foreground
      love.graphics.draw(foregroundImage, 0, 0, 0, imageScale)

      -- draw the foreground roommates
      roommates[2]:draw()
      roommates[3]:draw()
      roommates[4]:draw()

      --draw black "console"
      love.graphics.setColor( 0, 0, 0 )
      love.graphics.rectangle("fill", 0, 53 * imageScale, WINDOW_WIDTH, WINDOW_HEIGHT - (53 * imageScale))

      --draw text
      love.graphics.setColor( 255, 255, 255 )

      if gameState == 1 then --Turn Options
         love.graphics.print("WHAT DO YOU DO NOW?", 1 * imageScale, 54 * imageScale)
         for i, string in ipairs(turnOptions) do
            if turnSelect == i then
               love.graphics.rectangle("fill", 2 * imageScale, (54+2*i) * imageScale, SELECTION_WIDTH * imageScale, defaultFont:getHeight() )
               love.graphics.setColor( 0, 0, 0 )
            end
            love.graphics.print(i .. ") " .. string, 2 * imageScale, (54+2*i) * imageScale)
            love.graphics.setColor( 255, 255, 255 )
         end

      elseif gameState == 2 then --Restaurant Options
         love.graphics.print("WHERE DO WE EAT NOW?", 1 * imageScale, 54 * imageScale)
         if menusFound then
            love.graphics.print( "MENU", (53 + SELECTION_WIDTH) * imageScale, 54 * imageScale)
         end
         if costsFound then
            love.graphics.print( "COST", (63.5 + SELECTION_WIDTH) * imageScale, 54 * imageScale)
         end
         if delivFound then
            love.graphics.print( "DELIVERY?", (69 + SELECTION_WIDTH) * imageScale, 54 * imageScale)
         end
         if hoursFound then
            love.graphics.print( "CLOSES", (79 + SELECTION_WIDTH) * imageScale, 54 * imageScale)
         end
         for i=1, LOCATIONS_PER_PAGE do
            if locationSelect == i then
               love.graphics.rectangle("fill", 9 * imageScale, (54+2*i) * imageScale, SELECTION_WIDTH * imageScale, defaultFont:getHeight() )
               love.graphics.setColor( 0, 0, 0 )
            end
            local j = i + (pageSelect - 1) * LOCATIONS_PER_PAGE --Actual number in larger list
            if locationMasterList[j] then
               love.graphics.print( j .. ") " .. locationMasterList[j].name, 9 * imageScale, (54+2*i) * imageScale)
               love.graphics.setColor( 255, 255, 255 )
               love.graphics.print( "\"" .. locationMasterList[j].slogan .. "\"", (10 + SELECTION_WIDTH) * imageScale, (54+2*i) * imageScale)               
               if menusFound then
                  love.graphics.print( locationMasterList[j].genre, (50 + SELECTION_WIDTH) * imageScale, (54+2*i) * imageScale)
               end
               if costsFound then
                  love.graphics.print( locationMasterList[j].cost, (65 + SELECTION_WIDTH) * imageScale, (54+2*i) * imageScale)
               end
               if delivFound then
                  local delivStr = ""
                  if locationMasterList[j].delivery == 1 then
                     delivStr = "Yes"
                  else
                     delivStr = "No"
                  end
                  love.graphics.print( delivStr, (71 + SELECTION_WIDTH) * imageScale, (54+2*i) * imageScale)
               end
               if hoursFound then
                  love.graphics.print( locationMasterList[j].closingTime, (81 + SELECTION_WIDTH) * imageScale, (54+2*i) * imageScale)
               end
            end
            love.graphics.setColor( 255, 255, 255 )
         end
         

      elseif gameState == 3 then --Roommate Options
         love.graphics.print("WHO DO YOU ASK NOW?", 1 * imageScale, 54 * imageScale)
         for i=1, 4 do
            if roommateSelect == i then
               love.graphics.rectangle("fill", 2 * imageScale, (54+2*i) * imageScale, SELECTION_WIDTH * imageScale, defaultFont:getHeight() )
               love.graphics.setColor( 0, 0, 0 )
            end
            love.graphics.print(roommates[i].name, 4 * imageScale, (54+2*i) * imageScale)
            love.graphics.setColor( 255, 255, 255 )
         end
         
      elseif gameState == 4 then --Research Options
         love.graphics.print("WHAT DO YOU RESEARCH NOW?", 1 * imageScale, 54 * imageScale)
         for i, string in ipairs(researchOptions) do
            if researchSelect == i then
               love.graphics.rectangle("fill", 2 * imageScale, (54+2*i) * imageScale, SELECTION_WIDTH * imageScale, defaultFont:getHeight() )
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
         if speaker then
            speaker:stopTalking()
         end
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
               currentTraits[trait.name] = true
            end
         end
         gameState = 1
         sfx["select"]:play()
         -- or alternately, sfx["begin"]:play() for begin game
      end
   else
      --TODO: play boop sound
      if gameState == 1 then
         if key == "up" and turnSelect > 1 then
            turnSelect = turnSelect - 1
         elseif key == "down" and turnSelect < table.maxn(turnOptions) then
            turnSelect = turnSelect + 1
         elseif key == "return" or key == " " then
            gameState = turnSelect + 1 --selects between next gamestates
            turnSelect = 1
            sfx["select"]:play()
         end

      elseif gameState == 2 then
         if key == "up" and locationSelect > 1 then
            locationSelect = locationSelect - 1
         elseif key == "down" and locationSelect < LOCATIONS_PER_PAGE and locationMasterList[locationSelect+(pageSelect-1)*LOCATIONS_PER_PAGE+1] then
            locationSelect = locationSelect + 1
         elseif key == "left" and pageSelect > 1 then
            pageSelect = pageSelect - 1
            locationSelect = 1
         elseif key == "right" and pageSelect < ( table.maxn(locationMasterList) / LOCATIONS_PER_PAGE ) then
            pageSelect = pageSelect + 1
            locationSelect = 1
         elseif key == "return" or key == " " then
            sfx["select"]:play()
            local failure = false
            local location = locationMasterList[locationSelect + (pageSelect-1) * LOCATIONS_PER_PAGE]
            local currentHour = wallClock.time.hour
            if currentHour > location.closingTime then
               results = "You think about mentioning the possibility of eating at " .. location.name .. " but then realize that they are closed.\nYou sit in shameful awkward silence for 15 minutes."
               failure = true
            else
               for i, roomy in ipairs(roommates) do
                  for j, trait in ipairs(roomy.traits) do
                     if not failure then
                        if trait.name == "Troll" and trollFlag == 0 then
                           trollFlag = 1
                           troll = roomy
                        elseif not trait.delivery == 0 then
                           if trait.delivery > 0 and location.delivery == 0 then
                              results = roomy.name .. " is way too lazy to get food from anywhere that won't deliver. Looks like you're stuck here. 15 minutes passes."
                              failure = true
                           elseif trait.delivery < 0 and location.delivery == 1 then
                              results = roomy.name .. " is scared of telephones, so you can't bring yourself to call in a delivery order."
                              --roomy.name .. " is the only one with a phone.\nUnfortunately, " .. roomy:getPronoun(false) .. " is also deathly allergic to talking on the phone.\nOh well."
                              failure = true
                           end
                        elseif currentHour < trait.beginHour then
                           results = "It's a bit too early for " .. roomy.name .. " to eat now. " .. roomy:getPronoun(true) .. " isn't hungry yet, the bastard!"
                           failure = true
                        elseif currentHour >= trait.endHour then
                           results = roomy.name .. " can't eat after " .. roomy.endHour .. ", it's WAY too late for " .. roomy:getPronoun(false) .. ".\nGAME OVER."
                           gameOver = true
                           failure = true
                        elseif location.cost > trait.highestCost then
                           results = location.name .. " is WAY too expensive for " .. roomy.name .. ". Maybe you should be more considerate of " .. roomy:getPossessive(false) .. " monetary situation."
                           failure = true
                        elseif location.cost < trait.lowestCost then
                           results = roomy.name .. " can't stand eating at a place of such low caliber. Or maybe " .. roomy:getPronoun(false) .. "'s just a snob."
                           failure = true
                        elseif trait.dislikedGenres[location.genre] then
                           results = roomy.name .. " doesn't like the " .. location.genre .. " at " .. location.name .. "."
                           failure = true
                        end
                     end
                  end
               end
            end

            if not failure and trollFlag == 1 then
               failure = true
               trollFlag = 2
               results = troll.name .. " rejects your suggestion out of spite. Or maybe this is " .. troll:getPossessive(false) .. " way of\nletting you know that " .. troll:getPronoun(false) .. " likes you. You'll never know."
            elseif trollFlag == 1 then
               trollFlag = 0
            end
            if gameOver then
               --TODO: Game Over logic
            elseif failure then
               gameState = 5
               locationSelect = 1
               pageSelect = 1
               resultsTimer = true
            else
               --TODO: Win Game logic
            end
         elseif key == "backspace" then
            locationSelect = 1
            pageSelect = 1
            gameState = 1
            sfx["back"]:play()
         end

      elseif gameState == 3 then
         if key == "up" and roommateSelect > 1 then
            roommateSelect = roommateSelect - 1
         elseif key == "down" and roommateSelect < table.maxn(roommates) then
            roommateSelect = roommateSelect + 1
         elseif key == "return" or key == " " then
            sfx["select"]:play()
            results = "You ask " .. roommates[roommateSelect].name .. " for a suggestion. " .. roommates[roommateSelect]:getPronoun(true) .. " is pretty much useless. You spend 15 minutes recuperating."
            roommates[roommateSelect]:startTalking("I'm feelin' pizza.")
            gameState = 5 --go to results
            resultsTimer = true
         elseif key == "backspace" then
            roommateSelect = 1
            gameState = 1
            sfx["back"]:play()
         end

      elseif gameState == 4 then
         if key == "up" and researchSelect > 1 then
            researchSelect = researchSelect - 1
         elseif key == "down" and researchSelect < table.maxn(researchOptions) then
            researchSelect = researchSelect + 1
         elseif key == "return" or key == " " then
            sfx["select"]:play()
            if researchSelect == 1 then
               results = "You had to spend 15 minutes to refresh your memory on\nwhat type of food each restaurant serves its customers."
               menusFound = true
            elseif researchSelect == 2 then
               results = "It was a little tricky, but through the use of Yalp and Gaggle, you\nfound the price range of each restaurant."
               costsFound = true
            elseif researchSelect == 3 then
               results = "You had forgotten before, but now you've finally done it: put all\nthe phone numbers of delivery places on speed dial."
               delivFound = true
            elseif researchSelect == 4 then
               results = "You spend 15 minutes researching the hours of the restaurants\nand somehow manage to figure out when they all close."
               hoursFound = true
            end
            researchSelect = 1
            gameState = 5 --go to results
            resultsTimer = true
         elseif key == "backspace" then
            researchSelect = 1
            gameState = 1
            sfx["back"]:play()
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
      for i, roomy in ipairs(roommates) do
         local gender = "girl"
         if i == 1 or i == 4 then
            gender = "boy"
         end
         roomy:init(gender, roommateImages[1][i], roommateImages[2][i], roommateImages[3][i], i)
         for i, trait in ipairs(roommates[i].traits) do
            table.insert(currentTraits,trait)
            currentTraits[trait.name] = true
         end
      end
   end
end
