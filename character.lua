require 'config'

Character = {}
function Character:draw()
  love.graphics.draw(text_atlas, self.current_quad, self.x, self.y)
end
