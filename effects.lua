
local config = require "config"


MAXANGLE = 0.1

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

slope_1 = {}
slope_2 = {}
slope_3 = {}


for i = -1, 100 do
  slope_1[i] = math.random()*2.0 - 1.0
  slope_2[i] = math.random()*2.0 - 1.0
  slope_3[i] = math.random()*2.0 - 1.0
end

function samplePerlin(x, slope_obj)
  local lo = math.floor(x)
  local hi = lo + 1.0
  local dist = x - lo
  local loSlope = slope_obj[lo]
  local hiSlope = slope_obj[hi]

  local loPos = loSlope * dist
  local hiPos = -hiSlope * (1.0 - dist)
  local u = dist * dist * (3.0 - 2.0 * dist)
  print(loSlope, hiSlope, dist, loPos, hiPos, u)
  return (loPos * (1.0 - u)) + (hiPos * u)
end

function shake_camera_perlin(frame_number)
  local x = (frame_number*config.CAMERA_SHAKE.PERLIN) % 300
  x = x / 20.0
  local perlin = samplePerlin(x, slope_1)
  local perlin2 = samplePerlin(x, slope_2)

  local angle = config.CAMERA_SHAKE.MAX_ANGLE * samplePerlin(x, slope_3)
  local offsetx = config.CAMERA_SHAKE.MAX_X * perlin
  local offsety = config.CAMERA_SHAKE.MAX_Y * perlin2

  return 0, offsetx, offsety
end

function shake_camera()
  local angle = MAXANGLE * config.CAMERA_SHAKE.RANDOM * get_random_float()
  -- local offsetx = maxoffset * config.CAMERA_SHAKE.RANDOM * get_random_float()
  local offsety = maxoffset * config.CAMERA_SHAKE.RANDOM * get_random_float()

  local offsetx = 0

  return angle, offsetx, offsety
end




