local graphics = graphics or require "graphics"
local events = events or require "events"
local config = config or require "config"

local game = {}

game.tiles = config.TILES

game.frame_cnt = 0
game.animated_background = graphics.animated_background

function game:get_resolution()
  return self.tiles.pixel_width*self.tiles.width, self.tiles.pixel_height*self.tiles.height
end

function game:init()
  local characters = require "characters"
  local game_width, game_height = self:get_resolution()
  self.player = characters.Player:new(game_width/2, 0, 16*2, 24*2, 0, 0)
  self.animated = {}
end

function game:update(dt)
  if events:pushing_reset() then
    self.player.x = self.game_width / 2
    self.player.y = self.game_height / 2
  end
  self.player:update(dt, self.frame_cnt)
  self.frame_cnt = self.frame_cnt + 1
end

function game:draw()
  self.animated_background:draw()
  self.player:draw()
end

return game