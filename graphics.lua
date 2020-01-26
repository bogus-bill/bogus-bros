require 'config'
require "sprites"

local graphics = {}

local animated_background = {
  quads = back1,
  current_quad=1,
  speed=10,
  speed_ind=1,
  x=0,
  y=0
}

graphics.animated_background = animated_background

function animated_background:update()
  self.speed_ind = (self.speed_ind + 1) % self.speed
  if self.speed_ind == 1 then
    self.current_quad = self.current_quad % table.getn(self.quads)
    self.current_quad = self.current_quad + 1
  end
end

function animated_background:draw(scalex, scaley)
  animated_background:update()

  -- draw background 3 times at [-width, 0, +width] for scrolling
  local draw_at = {block_width, 0, -block_width}
  for _, offset in pairs(draw_at) do
    local xpos = self.x % block_width + offset
    local ypos = self.y
    love.graphics.draw(background_atlas, self.quads[self.current_quad], xpos, ypos, 0, scalex, scaley)
  end
end

return graphics