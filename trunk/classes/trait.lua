require 'class'

Trait = newclass("Trait")

function Trait:init(name, vegan, vegatarian, delivery, conflicts, highestCost, lowestCost, highestQuality, lowestQuality, favoriteGenres, dislikedGenres, beginHour, endHour)
   if name == nil then
      -- randomly select a trait
   else
      self.name = name
      self.vegan = vegan
      self.vegetarian = vegetarian
      self.delivery = delivery
      self.highestCost = highestCost
      self.lowestCost = lowestCost
      self.highestQuality = highestQuality
      self.lowestQuality = lowestQuality
      self.favoriteGenres = favoriteGenres
      self.dislikedGenres = dislikedGenres
      self.beginHour = beginHour
      self.endHour = endHour
      self.conflicts = {}
      
      -- need to delimit the conflicts list
      if conflicts then
         self.conflicts = split(conflicts, "; ")
      end
   end
end

function Trait:getRandomTrait(currentTraits)
   math.randomseed(socket.gettime())
   local randomIndex = math.random(table.maxn(traitMasterList))
   local masterTrait = traitMasterList[randomIndex]
   
   self.name = masterTrait.name
   self.vegan = masterTrait.vegan
   self.vegetarian = masterTrait.vegetarian
   self.delivery = masterTrait.delivery
   self.conflicts = masterTrait.conflicts
   self.highestCost = masterTrait.highestCost
   self.lowestCost = masterTrait.lowestCost
   self.highestQuality = masterTrait.highestQuality
   self.lowestQuality = masterTrait.lowestQuality
   self.favoriteGenres = masterTrait.favoriteGenres
   self.dislikedGenres = masterTrait.dislikedGenres
   self.beginHour = masterTrait.beginHour
   self.endHour = masterTrait.endHour
end

function Trait:__tostring()
   local string = self.name .. " conflicts: "
   
   for i, conflict in ipairs(self.conflicts) do
      string = string .. conflict .. ", "
   end
   
   return string
end