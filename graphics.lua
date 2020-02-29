local config = require 'config'
require "sprites"
love.graphics.setDefaultFilter("nearest", "nearest")

local graphics = {}

local animated_background = {
  quads = stars_background,
  current_quad=1,
  speed_ind=1,
  frame_period = 8, -- we want to switch frames 4 times a second
  cnt_dt = 0,
  x=0,
  y=0
}

graphics.animated_background = animated_background

function animated_background:update(dt)
  self.cnt_dt = self.cnt_dt + dt
  self.current_quad = (self.cnt_dt % 1) * self.frame_period
  self.current_quad = self.current_quad % 4
  self.current_quad = math.floor(self.current_quad) + 1
end

function animated_background:draw(x, y, angle)
  -- draw background 3 times at [-width, 0, +width] for scrolling
  local draw_at_x = {block_width, 0, -block_width}
  local draw_at_y = {block_height, 0, -block_height}
  for _, offset_x in pairs(draw_at_x) do
    -- for _, offset_y in pairs(draw_at_y) do
      local xpos = x % block_width + offset_x
      -- local ypos = y % block_height + offset_y
      local ypos = y
      love.graphics.draw(background_atlas, self.quads[self.current_quad], xpos, ypos, angle)
    -- end
  end
end

local Simpleanim = {}
setmetatable(Simpleanim, {__index=Drawable})

return graphics