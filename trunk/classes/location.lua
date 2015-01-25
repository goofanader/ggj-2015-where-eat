require 'class'

Location = newclass("Location")

-- location constructor
function Location:init(name, genre, cost, quality, delivery, closingTime, slogan)
   self.name = name
   self.genre = genre
   self.cost = tonumber(cost)
   self.quality = tonumber(quality)
   self.delivery = delivery
   self.closingTime = tonumber(closingTime)
   self.slogan = slogan
end

-- location's pretty print string
function Location:__tostring()
   return self.name .. " (\"" .. self.genre .. "\")"
end