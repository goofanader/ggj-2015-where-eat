require 'classes/additionalFunctions'
require 'classes/location'
require 'classes/trait'

-- globals of the csv files
traitMasterList = {}
genreMasterList = {}
local locationNormalList = {}
locationMasterList = {}

-- text option choices globals
turnOptions = {"Propose a place to eat","Ask a roommate for a suggestion","Research restaurants"}
researchOptions = {"Menus","Hours"}

function buildDataTables()
   local dataFolder = "media/data"
   
   --let's start with genre
   local file = love.filesystem.newFile(dataFolder .. "/Genres.csv")
   -- drop the first line since it's just the name of columns
   local isFirst = true
   
   --iterate through the lines of the file
   for line in file:lines() do
      if not isFirst then
         --insert the genre name into the master list
         table.insert(genreMasterList, line)
      end
   
      isFirst = false
   end
   
   file:close()
   
   --next, location
   file = love.filesystem.newFile(dataFolder .. "/Restaurants.csv")
   isFirst = true
   
   -- again, iterate through the lines of the file
   for line in file:lines() do
      if not isFirst then
         -- delimit on commas
         local delimitedList = split(line, ",")
         -- create a new Location object.
         -- "unpack(<table variable>)" automatically makes each item in a table as an input for a function. It's really handy~
         local newLocation = Location:new(unpack(delimitedList))
         
         --insert into the table
         table.insert(locationNormalList, newLocation)
         -- make a mapping between the name of a location and its object
         -- locationNormalList[newLocation.name] = newLocation
      end
      
      isFirst = false
   end
   
   file:close()
   
   --RANDOMIZE DA TABLE:
   math.randomseed(socket.gettime())
   local i = 1
   local imax = table.maxn(locationNormalList)
   local location
   while i < imax do
      location = locationNormalList[math.random(imax)]
      if not locationMasterList[location.name] then
         --insert into the table
         table.insert(locationMasterList, location)
         -- make a mapping between the name of a location and its object
         locationMasterList[location.name] = true
         i = i + 1
      end
   end
   
   --finally, trait
   file = love.filesystem.newFile(dataFolder .. "/Traits.csv")
   isFirst = true
   
   -- iterating yahoo
   for line in file:lines() do
      if not isFirst then
         -- delimit on comma
         local delimitedList = split(line, ",")
         
         -- the second column is "ignore", so if there's an x, don't add that trait
         if delimitedList[2] ~= "x" then
            -- remove the second column, it shouldn't be added to the object
            table.remove(delimitedList, 2)
            local newTrait = Trait:new(unpack(delimitedList))
            
            -- insert into the table
            table.insert(traitMasterList, newTrait)
            -- make a mapping between the trait name and its object
            traitMasterList[newTrait.name] = newTrait
         end
      end
      
      isFirst = false
   end
   
   file:close()
   
   --we're done!
end