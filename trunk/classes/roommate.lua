require 'class'
require 'classes/trait'

Roommate = newclass("Roommate")

-- roommate constructor
function Roommate:init(name, numTraits)
   self.name = name --this is more like "location", like Roommate A, Roommate B, etc.
   
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

-- it prints a pretty string about the roommate and their traits
function Roommate:__tostring()
   local ret = "Roommate " .. self.name .. ": "
   
   for i, trait in ipairs(self.traits) do
      ret = ret .. trait.name .. ", "
   end
   
   return ret
end