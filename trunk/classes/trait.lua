require 'class'

Trait = newclass("Trait")

--trait constructor. If no arguments are given, it will make a random trait.
function Trait:init(name, delivery, conflicts, highestCost, lowestCost, highestQuality, lowestQuality, dislikedGenres, beginHour, endHour)
   if name == nil then
      -- randomly select a trait
      self:getRandomTrait()
   else
      -- go for it, bro
      self.name = name
      self.delivery = delivery
      self.highestCost = tonumber(highestCost)
      self.lowestCost = tonumber(lowestCost)
      self.highestQuality = tonumber(highestQuality)
      self.lowestQuality = tonumber(lowestQuality)
      self.dislikedGenres = {}
      self.beginHour = tonumber(beginHour)
      self.endHour = tonumber(endHour)
      self.conflicts = {}
      
      -- need to delimit the conflicts list
      if conflicts then
         local delimitedList = split(conflicts, "; ")
         
         for i, conflict in ipairs(delimitedList) do
            -- map the conflicts so we can easily check
            self.conflicts[conflict] = true
         end
      end
      
      if dislikedGenres then
         local delimitedList = split(dislikedGenres, "; ")
         
         for i, genre in ipairs(delimitedList) do
            --map the genres so we can easily check
            self.dislikedGenres[genre] = true
         end
      end
   end
end

-- sets up this Trait to have a random trait from the master list.
function Trait:getRandomTrait()
   -- set up the random seed
   math.randomseed(socket.gettime())
   local randomIndex = math.random(table.maxn(traitMasterList))
   -- get the random trait
   local masterTrait = traitMasterList[randomIndex]
   
   -- set all the variables, wowee
   self.name = masterTrait.name
   self.delivery = masterTrait.delivery
   self.conflicts = masterTrait.conflicts
   self.highestCost = masterTrait.highestCost
   self.lowestCost = masterTrait.lowestCost
   self.highestQuality = masterTrait.highestQuality
   self.lowestQuality = masterTrait.lowestQuality
   self.dislikedGenres = masterTrait.dislikedGenres
   self.beginHour = masterTrait.beginHour
   self.endHour = masterTrait.endHour
end

-- check if this Trait conflicts with any of the traits in the list
function Trait:doesItConflict(traitsList)
   for i, trait in ipairs(traitsList) do
      if self.conflicts[trait.name] then
         return true
      end
   end
   
   -- it didn't conflict! hurrah
   return false
end

-- pretty print string
function Trait:__tostring()
   local string = self.name .. " conflicts: "
   
   for i, conflict in ipairs(self.conflicts) do
      string = string .. conflict .. ", "
   end
   
   return string
end