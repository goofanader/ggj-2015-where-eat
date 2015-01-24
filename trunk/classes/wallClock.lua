require 'class'

-- declare a new class called "WallClock"
WallClock = newclass("WallClock")

-- constructor/initialize a WallClock object
-- note the ":" - it means that the variable "self" is automatically added as an input. Otherwise, you can't use "self" in the function and it gets angry :(
-- note that you have to use ":" when calling a method of WallClock's anywhere in this program.
function WallClock:init(startingTime)
   self.startTime = startingTime
   self.time = self.startTime -- this is a Time object
   self.x = 19 --in relation to the background's original size
   self.y = 0 --in relation to the background's original size
end

-- call this in love.update(dt)
function WallClock:update(dt, minutesToAdd)
   --do something to update the clock
   self.time:update(dt)
   
   if minutesToAdd then
      self.time:addMinutes(minutesToAdd)
   end
end

-- call this in love.draw()
function WallClock:draw()
   --save the previous state of graphics
   local defaultFont = love.graphics.getFont() --save the font for the next context
   local r,g,b,a = love.graphics.getColor()
   
   -- Print the clock to the screen
   love.graphics.setColor(102, 153, 51) --a green color
   love.graphics.setFont(clockFont) --load the clock font specified in main.lua
   love.graphics.print(self.time:__tostring(), self.x * imageScale, self.y * imageScale, 0, imageScale)
   
   --set it back to whatever font was before
   love.graphics.setColor(r,g,b,a)
   love.graphics.setFont(defaultFont) 
end

-- tostring method so it prints out something nice during a call to "print()"
function WallClock:__tostring()
   return "Clock time: " .. self.time:__tostring()
end

--Declare a new class "Time"
Time = newclass("Time")

--Constructor for Time
function Time:init(hour, minute)
   self.hour = hour
   self.minute = minute
   self.dt = 0 -- time holds dt to know when to switch to no colon
   self.hasColon = 1 -- this is a "boolean" (kinda) to determine whether to print the colon of the time to the screen
end

-- nice string output for "print()" and the "love.draw()" method
function Time:__tostring()
   local addMinuteZero = "" --add zero to the minute only if it's greater than 10
   local addHourZero = "" --ditto above, except for the hours
   local colon = ":"
   
   -- add that zero character if minute's less than 10
   if self.minute < 10 then
      addMinuteZero = "0"
   end
   
   -- ditto above, except for hours
   if self.hour < 10 then
      addHourZero = "0"
   end
   
   -- if self.hasColon is -1 at the moment, that means we should not show the colon
   if self.hasColon < 1 then
      colon = " "
   end
   
   return addHourZero .. self.hour .. colon .. addMinuteZero .. self.minute
end

function Time:getHour()
   return self.hour
end

function Time:getMinute()
   return self.minute
end

function Time:getTime()
   return self.hour, self.minute
end

function Time:setHour(hour)
   self.hour = hour
end

function Time:setMinute(minute)
   self.minute = minute
end

function Time:setTime(hour, minute)
   self.hour = hour
   self.minute = minute
end

function Time:addMinutes(minutes)
   -- separate the number of hours to add from the minutes
   local addHours = math.floor(minutes / 60)
   local addMinutes = minutes - math.floor(minutes / 60) * 60
   
   --add the values in
   self.hour = self.hour + addHours
   self.minute = self.minute + addMinutes
   
   -- if the minutes went over 60, add the extra hour(s) into self.hour and reset self.minute
   if self.minute > 60 then
      addHours = math.floor(self.minute / 60)
      self.minute = self.minute - math.floor(self.minute / 60) * 60
      self.hour = self.hour + addHours
   end
   
   -- if self.hour went over 12 o' clock, reset back to 1
   if self.hour > 12 then
      self.hour = self.hour - math.floor(self.hour / 12) * 12
   end
end

function Time:update(dt)
   self.dt = self.dt + dt
   
   -- I picked 3/4ths of 1 second since it seemed like a nice speed for the colon to appear at
   -- you can change the number, if you like ~~~Phyllis
   if self.dt > .75 then
      self.dt = 0
      self.hasColon = self.hasColon * -1
   end
end