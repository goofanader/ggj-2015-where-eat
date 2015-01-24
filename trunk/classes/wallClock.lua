require 'class'

WallClock = newclass("WallClock")

function WallClock:init(startingTime)
   self.startTime = startingTime
   self.time = self.startTime
   self.x = 23 --in relation to the background's original size
   self.y = 0 --in relation to the background's original size
end

function WallClock:update(dt)
   --do something to update the clock
   self.time:update(dt)
end

function WallClock:draw()
   --save the previous state of graphics
   local defaultFont = love.graphics.getFont() --save the font for the next context
   local r,g,b,a = love.graphics.getColor()
   
   love.graphics.setColor(102, 153, 51) --a green color
   love.graphics.setFont(clockFont) --load the clock font specified in main.lua
   local fontScale = 10--WINDOW_HEIGHT / clockFont:getLineHeight()
   love.graphics.print(self.time:__tostring(), self.x * fontScale, self.y * fontScale, 0, fontScale)
   
   love.graphics.setColor(r,g,b,a)
   love.graphics.setFont(defaultFont) --set it back to whatever font was before
end

function WallClock:__tostring()
   return "Clock time: " .. self.time
end

--function WallClock:get

Time = newclass("Time")

function Time:init(hour, minute)
   self.hour = hour
   self.minute = minute
   self.dt = 0
   self.hasColon = 1
end

function Time:__tostring()
   local addZero = ""
   local colon = ":"
   
   if self.minute < 10 then
      addZero = "0"
   end
   
   if self.hasColon < 1 then
      colon = " "
   end
   
   return self.hour .. colon .. addZero .. self.minute
end

function Time:getHour()
   return self.hour
end

function Time:getMinute()
   return self.minute
end

function Time:setHour(hour)
   self.hour = hour
end

function Time:setMinute(minute)
   self.minute = minute
end

function Time:update(dt)
   self.dt = self.dt + dt
   
   if self.dt > .75 then
      self.dt = 0
      self.hasColon = self.hasColon * -1
   end
end