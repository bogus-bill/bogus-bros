require 'config'

Character = {}
function Character:draw()
  love.graphics.draw(mario_atlas, self.current_quad, self.x, self.y, 0, self.scalex, self.scaley)
end
