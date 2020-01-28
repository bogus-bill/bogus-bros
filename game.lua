local graphics = graphics or require "graphics"
local events = events or require "events"
local config = config or require "config"
local objects = require "objects"

require "lib/physics"

local game = {}

game.tiles = config.TILES

game.frame_cnt = 0
game.animated_background = graphics.animated_background

function game:get_coordinates()
  -- fit mario in the middle of the screen
  local playerx, playery = self.player.x, self.player.y
end

function game:get_resolution()
  return self.tiles.pixel_width*self.tiles.width, self.tiles.pixel_height*self.tiles.height
end

function game:init()
  local characters = require "characters"
  local game_width, game_height = self:get_resolution()
  self.player = characters.Player:new(game_width/2, 0, 16*2, 24*2, 0, 0)
  self.animated = {}
  self.luna = objects.Luna.new()
end

function game:update(dt)
  if events:pushing_reset() then
    self.player.x, self.player.y = self:get_resolution()
  end
  self.player:update(dt, self.frame_cnt)
  self.animated_background:update(dt, self.frame_cnt)
  self.frame_cnt = self.frame_cnt + 1
end

function game:draw()
  local game_width, game_height = self:get_resolution()
  self.animated_background:draw(1, 1, -self.player.x, 0)
  -- self.player:draw(-self.player.x + game_width/2, 0)
  self.player:draw(0, 0)
  -- self.luna:draw(1, 1, -self.player.x, 0, self.frame_cnt)
  -- love.graphics.rectangle("fill", 20, 50, 60, 120 )
  -- love.graphics.draw(objects_atlas, , 20, 50, 0, self.scalex, self.scaley)
  -- for ind, elem in ipairs(self.player.statestack) do
  --   table.insert(sometable, elem.x)
  --   table.insert(sometable, elem.y)
  -- end
  -- if self.frame_cnt > 10 then
  --   love.graphics.line(self.player.x, self.player.y, self.player.statestack[5].x, self.player.statestack[5].y)
  -- end
  local x2, y2, width2, height2 = 300, 300, 100, 100
  local mode = 'line'
  local is_collision = box2box_collide(self.player.x, self.player.y, self.player.width, self.player.height,
                                   x2, y2, width2, height2)
  if is_collision then
    mode = 'fill'
  end
  love.graphics.rectangle(mode, x2, y2, width2, height2)
end

return game