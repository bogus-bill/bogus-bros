require "sprites"

local objects = {}

local Luna = {
  current_quad=love.graphics.newQuad(0, 0, 24, 24, objects_atlas:getDimensions()),
  texture_atlas=objects_atlas,
  scalex=1, scaley=1,
}

function Luna.new()
  local obj = {}
  setmetatable(obj,  {__index=Luna})
  return obj
end

-- function Luna:draw()
--   love.graphics.draw(self.texture_atlas, self.current_quad, self.x, self.y, 0, self.scalex, self.scaley)
-- end

objects.Luna = Luna

return objects

