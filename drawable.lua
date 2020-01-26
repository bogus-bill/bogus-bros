require 'config'

local drawable = {}

function drawable:draw()
  love.graphics.draw(self.texture_atlas, self.current_quad, self.x, self.y, 0, self.scalex, self.scaley)
end

return drawable