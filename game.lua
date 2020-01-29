local graphics = graphics or require "graphics"
local events = events or require "events"
local config = config or require "config"
local objects = require "objects"
local physics = require "lib/physics"

local game = {}

game.tiles = config.TILES

game.frame_cnt = 0
game.animated_background = graphics.animated_background

require "effects"

function game:get_coordinates()
  -- fit mario in the middle of the screen
  local playerx, playery = self.player.x, self.player.y
end

function game:get_resolution()
  return self.tiles.pixel_width*self.tiles.width, self.tiles.pixel_height*self.tiles.height
end

local game_width, game_height = game:get_resolution()

function game:init()
  local characters = require "characters"
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

  local player = self.player

  camera:center_on(player.x, player.y, player.width, player.height)
end

camera = {
  x = 0,
  y = 0,
}

function camera:center_on(x, y, width, height)
  local object_center  = (x + width/2)
  self.x = object_center - game_width/2

  self.x = math.max(0, self.x)
  self.x = math.min(self.x, 2000)
end

function camera:update()
  if love.keyboard.isDown("u") then
    camera.x = camera.x + 2
  elseif love.keyboard.isDown("y") then
    camera.x = camera.x - 2
  end
end

function camera:to_screen_position(x, y)
  return x-self.x, y-self.y
end

function game:draw()
  local player = self.player

  -- self.animated_background:draw(1, 1, -self.player.x, 0)
  -- self.player:draw(-self.player.x + game_width/2, 0)
  local player_x, player_y = camera:to_screen_position(self.player.x, self.player.y)
  local back_x, back_y = camera:to_screen_position(self.animated_background.x, self.animated_background.y)
  local rect_x, rect_y = camera:to_screen_position(300, 300)

  self.animated_background:draw(back_x, back_y)


  self.player:draw(player_x, player_y)

  local mode = 'line'
  local is_collision = self.player:collide_bbox(300, 300, 50, 100)
  if is_collision then
    mode = 'fill'
  end
  love.graphics.rectangle(mode, rect_x, rect_y, 50, 100)


end

return game