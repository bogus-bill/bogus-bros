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

function game:add_key_control(key, value, step)
  if love.keyboard.isDown(key) then
    if love.keyboard.isDown("lshift") then
      value = value - step
    else
      value = value + step
    end
  end
  return value
end

function game:update_test_mode(dt)
  config.GRAVITYSPEED = game:add_key_control("u", config.GRAVITYSPEED, 0.1)
  config.DEC = game:add_key_control("i", config.DEC, 0.01)
  config.ACCR = game:add_key_control("o", config.ACCR, 0.1)
  config.JUMPSPEED = game:add_key_control("p", config.JUMPSPEED, 0.01)
  config.FRC = game:add_key_control("j", config.FRC, 0.01)
  config.MAXSPEED_R = game:add_key_control("k", config.MAXSPEED_R, 0.1)
  config.CAMERA_SHAKE["RANDOM"] = game:add_key_control("l", config.CAMERA_SHAKE["RANDOM"], 0.001)
  config.CAMERA_LAZY_FOLLOW["value"] = game:add_key_control("g", config.CAMERA_LAZY_FOLLOW["value"], 0.001)
  love.graphics.print(config.GRAVITYSPEED                   ,150, 200)
  love.graphics.print(config.DEC                            ,150, 220)
  love.graphics.print(config.ACCR                           ,150, 240)
  love.graphics.print(config.JUMPSPEED                      ,150, 260)
  love.graphics.print(config.FRC                            ,150, 280)
  love.graphics.print(config.MAXSPEED_R                     ,150, 300)
  love.graphics.print(config.CAMERA_SHAKE["RANDOM"]         ,150, 320)
  love.graphics.print(config.CAMERA_LAZY_FOLLOW["value"]    ,150, 340)

  love.graphics.print("gravity u"                           ,0,   200)
  love.graphics.print("dec i"                               ,0,   220)
  love.graphics.print("accr o"                              ,0,   240)
  love.graphics.print("max jump speed p"                    ,0,   260)
  love.graphics.print("friction j"                          ,0,   280)
  love.graphics.print("maxspeedr k"                         ,0,   300)
  love.graphics.print("camera shake l"                      ,0,   320)
  love.graphics.print("camera lazy follow"                  ,0,   340)
end

function game:update(dt)
  if events:pushing_reset() then
    self.player.x, self.player.y = self:get_resolution()
  end
  self.player:update(dt, self.frame_cnt)
  self.animated_background:update(dt, self.frame_cnt)
  self.frame_cnt = self.frame_cnt + 1

  local player = self.player

  -- camera:center_on(player.x, player.y, player.width, player.height)
  camera:follow_lazily(player.x, player.y, player.width, player.height)
end

camera = {
  x = 0,
  y = 0,
}

function camera:follow_lazily(x, y, width, height)
  local object_centerx, object_centery = (x + width/2), (y + height/2)
  local ideal_x = object_centerx - game_width/2
  local ideal_y = object_centery - game_height/2

  self.x = self.x*config.CAMERA_LAZY_FOLLOW["value"] + ideal_x*(1.0-config.CAMERA_LAZY_FOLLOW["value"])
  self.y = self.y*0.90 + ideal_y*0.10

  self.x = math.max(0, self.x)
  self.x = math.min(self.x, 2000)
  self.y = math.min(self.y, 0)
end

function camera:center_on(x, y, width, height)
  local object_center = (x + width/2)
  self.x = object_center - game_width/2
  self.y = (y + height/2) - game_height/2

  self.x = math.max(0, self.x)
  self.x = math.min(self.x, 2000)

  -- self.y = math.max(0, self.y)
  self.y = math.min(self.y, 0)
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

game.ennemies = {}
game.effects = {}

function game:draw_all()
  if love.keyboard.isDown("m") then
    local angle, offx, offy = shake_camera()
    camera.x = camera.x + offx
    camera.y = camera.y + offy
  end
  -- local drawables = {self.animated_background, self.effects, self.ennemies, self.player}

  local drawables = {self.animated_background, self.player}

  for _, object in pairs(drawables) do
      local obj_x, obj_y = camera:to_screen_position(object.x, object.y)
      object:draw(obj_x, obj_y)
  end
end

function game:draw()
  self:draw_all()
  -- offx, offy, angle = shake_camera()

  -- local mode = 'line'
  -- local is_collision = self.player:collide_bbox(300, 300, 50, 100)
  -- if is_collision then
  --   mode = 'fill'
  -- end
  -- love.graphics.rectangle(mode, rect_x, rect_y, 50, 100)
end


return game