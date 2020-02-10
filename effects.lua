
local config = require "config"


MAXANGLE = 0.1

maxoffset = 20.0

-- trauma level between [0, 1]
-- camera shake is trauma2 or trauma3:
-- trauma 0.30 0.60 0.90 are 3% 22% 73%

function lerp(a, b, w)
  -- w between 0.0 and 1.0
  -- a and b floats 
  -- interpolation between a and b linear
  return (1.0 - w) * a + w * b
end

function dotGradient(ix, iy, x, y)
  dx = x - ix*1.0
  dy = y - iy*1.0

  return (dx * gradient)

end

function get_random_float()
  local num = math.random() * 2 - 1.0
  return num
end

function shake_camera()
  local angle = MAXANGLE * config.CAMERA_SHAKE.RANDOM * get_random_float()
  local offsetx = maxoffset * config.CAMERA_SHAKE.RANDOM * get_random_float()
  local offsety = maxoffset * config.CAMERA_SHAKE.RANDOM * get_random_float()

  print(angle, offsetx, offsety)
  return angle, offsetx, offsety
end




