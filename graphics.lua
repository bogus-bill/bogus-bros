require 'config'

animated_background = {
  quads = back1,
  current_quad=1,
  speed=10,
  speed_ind=1,
}

function animated_background:draw()
  love.graphics.draw(background_atlas, self.quads[self.current_quad], self.x, self.y, 0, 2, 2)
  self.speed_ind = (self.speed_ind + 1) % self.speed
  if self.speed_ind == 1 then
    self.current_quad = self.current_quad % table.getn(self.quads)
    self.current_quad = self.current_quad + 1
  end
end
