require "sprites"

local objects = {}
local Luna = {}

function Luna.new()
  local w, h = objects_atlas:getDimensions()
  local obj = {
    current_quad=love.graphics.newQuad(0, 0, w, h, objects_atlas:getDimensions()),
    texture_atlas=objects_atlas,
    scalex=1, scaley=1,
    x=100, y=150,
  }
  setmetatable(obj,  {__index=Luna})
  return obj
end

function Luna:draw(scalex, scaley, offsetx, offsety, frame_cnt)
  local rotation = (frame_cnt) / (2 * math.pi)
  rotation = 0
  -- drawing stairs of moons
  for a=1,10 do
    love.graphics.draw(self.texture_atlas, self.current_quad, self.x + offsetx + a*20, self.y + offsety + a*20, rotation, self.scalex/5, self.scaley/5)
  end
end

objects.Luna = Luna

return objects