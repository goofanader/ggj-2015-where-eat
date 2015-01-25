require 'class'

Location = newclass("Location")

-- location constructor
function Location:init(name, genre, cost, quality, vegetarian, vegan, delivery, closingTime, slogan)
   self.name = name
   self.genre = genre
   self.cost = cost
   self.quality = quality
   self.vegetarian = vegetarian
   self.vegan = vegan
   self.delivery = delivery
   self.closingTime = closingTime
   self.slogan = slogan
end

-- location's pretty print string
function Location:__tostring()
   return self.name .. " (" .. self.genre .. ")"
end