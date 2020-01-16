require 'config'

Character = {}
function Character:draw()
  love.graphics.draw(text_atlas, self.current_quad, self.x, self.y, 0, self.scalex or 1, self.scaley or 1)
end
