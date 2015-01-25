require 'class'
require 'classes/trait'

Roommate = newclass("Roommate")

local randomName = {["girl"] = {"Alice", "Amy", "Joan", "Jamie", "Roberta", "Andrea", "Phyllis", "Isabelle", "Jessica", "Sheila", "Kelly", "Hanna", "Madeline", "Jill", "Stephanie", "Jae", "Cecelia", "Melanie", "Anne", "Barbara"},
   ["boy"] = {"Andrew", "Alex", "Aaron", "Spencer", "Daniel", "David", "Michael", "John", "Sampson", "Frank", "Samuel", "Tom", "Jerry", "Ashburton", "Jack", "Tam", "Paul", "Charlie", "Nikola", "Perry", "Brian", "Sylvester","Xavier", "Bernard", "Tim", "George", "Nathan", "Jose", "Jesus", "Ben", "Simon", "Edward", "Rudolph", "William", "Horton", "Scott", "Peter", "Brock", "Emilio", "Joshua", "Leonardo", "Chris", "Tylor"}}

local CHANGE_CHANCE = .2--.95
local ANI_SPEED = .50
local MAX_FRAMES = 12
local PAUSE_TIME_ROOMMATES = 5

-- roommate constructor
function Roommate:init(gender, imageFiles, textBox, textBoxCoordinates, seed, name, numTraits)
   self.gender = gender
   self.name = name
   self.imageFiles = imageFiles
   self.textBox = textBox
   self.hasTextbox = false
   self.text = ""
   self.textBoxCoordinates = textBoxCoordinates
   self.currFrame = 1
   self.dt = 0
   self.random = love.math.newRandomGenerator()
   self.seed = seed
   self.frameCount = 0
   self.isAltFrame = false
   self.random:setSeed(self.seed * 228 * socket.gettime()*1000)
   self.random:random()
   self.random:random()

   --math.randomseed(seed + socket.gettime() * 1000)
   --if self.random:random() > CHANGE_CHANCE then
   self.isPaused = false
   --else
   --self.isPaused = true
   --end

   if not self.name then
      self.name = randomName[gender][self.random:random(table.maxn(randomName[gender]))]
   end

   self.traits = {}

   --get the number of traits this roommate's gonna get
   if not numTraits then
      numTraits = 2 --self.random:random(2,3)
   end

   -- loop through until we get 4 valid traits
   local i = 1
   while i <= numTraits do
      -- create a random new trait
      local newTrait = Trait:new()

      -- as long as the trait isn't already added and doesn't conflict with the other traits, insert it in
      if not self.traits[newTrait.name] and not currentTraits[newTrait.name] and not newTrait:doesItConflict(self.traits) and not newTrait:doesItConflict(currentTraits) then
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

function Roommate:getPossessive(isCapitalized)
   if self.gender == "girl" then
      if isCapitalized then
         return "Her"
      else
         return "her"
      end
   elseif self.gender == "boy" then
      if isCapitalized then
         return "His"
      else
         return "his"
      end
   end
end

function Roommate:startTalking(textToSay)
   self.hasTextbox = true
   self.text = textToSay
   speaker = self
end

function Roommate:stopTalking()
   self.hasTextbox = false
end

function Roommate:draw()
   local r,g,b,a = love.graphics.getColor()
   local origFont = love.graphics.getFont()
   love.graphics.setColor(255,255,255,255)
   love.graphics.setFont(defaultFont)

   if self.imageFiles then
      love.graphics.draw(self.imageFiles[self.currFrame], 0,0,0, imageScale)
   end

   if self.hasTextbox and self.textBox then
      love.graphics.draw(self.textBox, 0,0,0, imageScale)
      love.graphics.setColor(0,0,0)
      love.graphics.print(self.text, self.textBoxCoordinates[1] * imageScale, self.textBoxCoordinates[2] * imageScale)
   end

   love.graphics.setColor(r,g,b,a)
   love.graphics.setFont(origFont)
end

function Roommate:update(dt)
   self.dt = self.dt + dt
   
   local altFrame = 2
   if self.isAltFrame then
      altFrame = 3
   end
   
   if not self.isPaused then
      if self.dt > ANI_SPEED then
         self.dt = 0

         if self.random:random(2) == 2 then
            self.currFrame = altFrame
         else
            self.currFrame = 1
         end

         self.frameCount = self.frameCount + 1

         if self.frameCount > MAX_FRAMES then
            --self.random:setSeed(self.seed * 113)
            if self.random:random() > CHANGE_CHANCE then
               self.isAltFrame = not self.isAltFrame
               self.currFrame = 1
            end

            self.frameCount = 1
         end
      end
   else
      if self.dt > PAUSE_TIME_ROOMMATES then
         self.random:setSeed(os.time() * self.seed)
         if self.random:random() > CHANGE_CHANCE then
            self.isPaused = not self.isPaused
            self.currFrame = 1
         end
         self.dt = 0
      end
   end

   --self.random:setSeed(os.time())
   --if self.random:random() > CHANGE_CHANCE then
   --self.isPaused = not self.isPaused
   --end
end

-- it prints a pretty string about the roommate and their traits
function Roommate:__tostring()
   local ret = "Roommate " .. self.name .. ": "

   for i, trait in ipairs(self.traits) do
      ret = ret .. trait.name .. ", "
   end

   return ret
end