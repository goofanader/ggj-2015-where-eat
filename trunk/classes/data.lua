require 'classes/additionalFunctions'
require 'classes/location'
require 'classes/trait'

traitMasterList = {}
genreMasterList = {}
locationMasterList = {}

function buildDataTables()
   local dataFolder = "media/data"
   
   --let's start with genre
   local file = love.filesystem.newFile(dataFolder .. "/Genres.csv")
   -- drop the first line since it's just the name of columns
   local isFirst = true
   for line in file:lines() do
      if not isFirst then
         table.insert(genreMasterList, line)
      end
   
      isFirst = false
   end
   
   file:close()
   
   --next, location
   file = love.filesystem.newFile(dataFolder .. "/Restaurants.csv")
   isFirst = true
   
   for line in file:lines() do
      if not isFirst then
         local delimitedList = split(line, ",")
         local newLocation = Location:new(unpack(delimitedList))
         
         table.insert(locationMasterList, newLocation)
         locationMasterList[newLocation.name] = newLocation
      end
      
      isFirst = false
   end
   
   file:close()
   
   --finally, trait
   file = love.filesystem.newFile(dataFolder .. "/Traits.csv")
   isFirst = true
   
   for line in file:lines() do
      if not isFirst then
         local delimitedList = split(line, ",")
         
         if delimitedList[2] ~= "x" then
            table.remove(delimitedList, 2)
            local newTrait = Trait:new(unpack(delimitedList))
            
            print(newTrait)
            table.insert(traitMasterList, newTrait)
            traitMasterList[newTrait.name] = newTrait
         end
      end
      
      isFirst = false
   end
   
   file:close()
   
   --we're done!
end