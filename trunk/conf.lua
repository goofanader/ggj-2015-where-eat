local WINDOW_WIDTH = 1280
local WINDOW_HEIGHT = 720

function love.conf(t)
   t.window.width = WINDOW_WIDTH
   t.window.height = WINDOW_HEIGHT
   --t.modules.joystick = false
   --t.modules.physics = false
   t.version = "0.9.1"
   t.console = false
end
