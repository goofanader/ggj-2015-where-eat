require 'class'
require 'classes/trait'

Roommate = newclass("Roommate")

local randomName = {["girl"] = {"Alice", "Amy", "Joan", "Jamie", "Roberta", "Andrea", "Phyllis"},
   ["boy"] = {"Andrew", "Alex", "Aaron", "Spencer", "Daniel", "David", "Michael"}}

-- roommate constructor
function Roommate:init(gender, imageFile, name, numTraits)
   self.gender = gender
   self.name = name
   self.imageFile = imageFile

   if not self.name then
      math.randomseed(socket.gettime())
      self.name = randomName[gender][math.random(table.maxn(randomName[gender]))]
   end

   self.traits = {}

   --get the number of traits this roommate's gonna get
   if not numTraits then
      math.randomseed(socket.gettime())
      numTraits = math.random(2,4) --I just picked 4, we can always change it
   end

   -- loop through until we get 4 valid traits
   local i = 1
   while i <= numTraits do
      -- create a random new trait
      local newTrait = Trait:new()

      -- as long as the trait isn't already added and doesn't conflict with the other traits, insert it in
      if not self.traits[newTrait.name] and not newTrait:doesItConflict(self.traits) then
         table.insert(self.traits, newTrait)
         -- map the trait name, as well
         self.traits[newTrait.name] = newTrait
         -- increment the counter
         i = i + 1
      end
   end
end

function Roommate:getPronoun(isCapitalized)
   if self.gender == "girl" then
      if isCapitalized then
         return "She"
      else
         return "she"
      end
   elseif self.gender == "boy" then
      if isCapitalized then
         return "He"
      else
         return "he"
      end
   end
end

function Roommate:startTalking()
end

function Roommate:stopTalking()
end

function Roommate:draw()
   local r,g,b,a = love.graphics.getColor()
   love.graphics.setColor(255,255,255,0)
   love.graphics.draw(self.imageFile, 0,0,0, imageScale)
   love.graphics.setColor(r,g,b,a)
end

function Roommate:update(dt)
end

-- it prints a pretty string about the roommate and their traits
function Roommate:__tostring()
   local ret = "Roommate " .. self.name .. ": "

   for i, trait in ipairs(self.traits) do
      ret = ret .. trait.name .. ", "
   end

   return ret
end