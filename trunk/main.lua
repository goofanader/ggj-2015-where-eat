--What Do We Eat For Dinner?
--A game by Andrew & Phyllis

function love.load()
   love.mouse.setCursor(love.mouse.newCursor("media/mouse.png"))
   love.graphics.setDefaultFilter("nearest","nearest")
   love.graphics.setNewFont("media/04B_03__.TTF",16)
   
   --remove when we add a picture background
   love.graphics.setBackgroundColor( 255, 255, 255 )
   
   gameState = 1
   turnSelect = 1
   restaurantSelect = 1
   roommateSelect = 1
   researchSelect = 1
end

function love.draw()
   --draw black "console"
   love.graphics.setColor( 0, 0, 0 )
   love.graphics.rectangle("fill", 0, 530, 1280, 190 )
   
   --draw text
   love.graphics.setColor( 255, 255, 255 )
   love.graphics.print("MENU", 50, 540) --Screen size is 1280x720
   
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
      