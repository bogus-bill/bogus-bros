require 'config'

Character = {}
function Character:draw(scalex, scaley)
  love.graphics.draw(text_atlas, self.current_quad, self.x, self.y, 0, scalex or 1, scaley or 1)
end
