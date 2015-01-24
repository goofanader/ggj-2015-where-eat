require 'class'
require 'classes/trait'

Roommate = newclass("Roommate")

function Roommate:init(name, numTraits)
   self.name = name --this is more like "location", like Roommate A, Roommate B, etc.
   
   self.traits = {}
   
   --get the number of traits this roommate's gonna get
   if not numTraits then
      math.randomseed(socket.gettime())
      numTraits = math.random(6) --I just picked 4, we can always change it
   end
   
   local i = 1
   while i <= numTraits do
      local newTrait = Trait:new()
      
      if not self.traits[newTrait.name] then
         table.insert(self.traits, newTrait)
         self.traits[newTrait.name] = newTrait
         i = i + 1
      end
   end
end

function Roommate:__tostring()
   local ret = "Roommate " .. self.name .. ": "
   
   for i, trait in ipairs(self.traits) do
      ret = ret .. trait.name .. ", "
   end
   
   return ret
end