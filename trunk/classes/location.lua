require 'class'

Location = newclass("Location")

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

function Location:__tostring()
   return self.name .. "(" .. self.genre .. ")"
end