local graphics = require "graphics"
local events = require "events"
local config = require "config"
local objects = require "objects"
local physics = require "lib/physics"
local Drawable = require "lib/drawable"
local Camera = require "camera"
local utils = require "lib/utils"
local Levels = require "levels"

local game = {}

game.tiles = config.TILES

game.frame_cnt = 1
game.animated_background = graphics.animated_background

require "effects"

local throwables = {}

local Rect = {
  x=0,
  y=0,
  width = 32,
  height = 32,
}

function Rect.new(x, y, width, height, quad)
  local obj = {x=x, y=y, width=width, height=height, quad=quad}
  setmetatable(obj, {__index=Rect})
  return obj
end

function Rect:draw()
  love.graphics.rectangle(self.x, self.y, self.width, self.height)
end

rects = {}

function game:get_floors()
  return self:get_resolution()
  -- TODO: change to upper line of level lines
end

function game:load_level(level)
  self.level = level
  print(string.format("level %s loaded", level.name))
  
  for _, tile in pairs(level.tile_lines) do
      for x=0, tile.width do
        rect_x, rect_y = to_upperleft(x*15, tile.y*15, 32, config.TILES.height*config.TILES.pixel_height)
        local rec = Tile.new(rect_x, rect_y, 100*32, 32, tile.img_data)
        table.insert(rects, rec)
      end
  end

  for _, tile in pairs(level.misc) do
    local rect_x, rect_y = to_upperleft(tile.x*15, tile.y*15, 32, config.TILES.height*config.TILES.pixel_height)
    local tile = Tile.new(rect_x, rect_y, 32*100, 32, tile.img_data)
    table.insert(rects, tile)
  end

end

function game:get_resolution()
  return self.tiles.pixel_width*self.tiles.width, self.tiles.pixel_height*self.tiles.height
end

local game_width, game_height = game:get_resolution()

function game:init()
  game:load_level(Levels.level1)
  camera = Camera:new(0, 0, game_width, game_height)
  self.camera = camera
  local characters = require "characters"
  self.player = characters.Player:new(game_width/2, 0, 15*2, 24*2, 0, 0)
  self.animated = {}
  self.luna = objects.Luna.new()
  self.slow_motion = false

  -- self:throw_rectangle(rect)

end

function add_key_control(key, value, step)
  if love.keyboard.isDown(key) then
    if love.keyboard.isDown("lctrl") then
      value = value - step
    else
      value = value + step
    end
  end
  return value
end

function game:throw_rectangle()
  local rect = Rect.new(self.player.x, self.player.y)
  table.insert(throwables, rect)
end

function game:update_test_mode()
  config.GRAVITYSPEED = add_key_control("u", config.GRAVITYSPEED, 0.1)
  config.DEC = add_key_control("i", config.DEC, 0.2)
  config.ACCR = add_key_control("o", config.ACCR, 0.1)
  config.JUMPSPEED = add_key_control("p", config.JUMPSPEED, 0.01)
  config.FRC = add_key_control("j", config.FRC, 0.2)
  config.MAXSPEED_R = add_key_control("k", config.MAXSPEED_R, 0.1)
  config.CAMERA_SHAKE["PERLIN"] = add_key_control("l", config.CAMERA_SHAKE["PERLIN"], 0.01)
  config.CAMERA_LAZY_FOLLOW["value"] = add_key_control("g", config.CAMERA_LAZY_FOLLOW["value"], 0.001)
  config.CAMERA_SHAKE.MAX_X = add_key_control("f", config.CAMERA_SHAKE.MAX_X, 0.5)
end

function game:draw_test_mode()
  love.graphics.print(config.GRAVITYSPEED                   ,150, 200-200)
  love.graphics.print(config.DEC                            ,150, 220-200)
  love.graphics.print(config.ACCR                           ,150, 240-200)
  love.graphics.print(config.JUMPSPEED                      ,150, 260-200)
  love.graphics.print(config.FRC                            ,150, 280-200)
  love.graphics.print(config.MAXSPEED_R                     ,150, 300-200)
  love.graphics.print(config.CAMERA_SHAKE["PERLIN"]         ,150, 320-200)
  love.graphics.print(config.CAMERA_LAZY_FOLLOW["value"]    ,150, 340-200)
  love.graphics.print(config.CAMERA_SHAKE.MAX_X             ,150, 360-200)

  love.graphics.print("gravity u"                                          ,0,   200-200)
  love.graphics.print("dec i"                                              ,0,   220-200)
  love.graphics.print("accr o"                                             ,0,   240-200)
  love.graphics.print("max jump speed p"                                   ,0,   260-200)
  love.graphics.print("friction j"                                         ,0,   280-200)
  love.graphics.print("maxspeedr k"                                        ,0,   300-200)
  love.graphics.print("camera shake l"                                     ,0,   320-200)
  love.graphics.print("camera lazy follow g"                               ,0,   340-200)
  love.graphics.print('camera shake MAX_X f'                               ,0,   360-200)
  love.graphics.print("FPS: "..love.timer.getFPS()                         ,300, 360-200)
end

function game:update(dt)
  self.dt = dt
  self.frame_cnt = self.frame_cnt + 1
  self.player.frame_cnt = self.frame_cnt

  if events:pushing_reset() then
    self.player.x, self.player.y = self:get_resolution()
  end
  self.player:update(dt, self.frame_cnt)
  self.animated_background:update(dt, self.frame_cnt)
  
  for _, th in pairs(throwables) do
    th.update()
  end

  local player = self.player

  camera_type = config.CAMERATYPE or "center_on"
  if camera_type == "center_on" then
    camera:center_on(player.x, player.y, player.width, player.height)
  elseif camera_type == "follow_lazily" then
    camera:follow_lazily(player.x, player.y, player.width, player.height, self.dt)
  end
  
  self:update_test_mode()
end

local frame_number = 0

function game:is_slow_motion()
  if self.slow_motion then 
    return true
  end
  return false
end

function game:activate_slow_motion(frequency)
  self.slow_motion = {
    frequency=frequency
  }
end


function game:draw_backgrounds()
  local backgrounds = {self.animated_background}
  for _, object in pairs(backgrounds) do
    obj_x, obj_y = camera:to_screen_position(object.x, object.y)
    object:draw(obj_x, obj_y)
  end
end

function game:draw_player()
    local animated = {self.player}
    for _, object in pairs(animated) do
      if object.statestack and table.getn(object.statestack) > 0 and object.interpolated_x then
        obj_x, obj_y = camera:to_screen_position(object.interpolated_x, object.interpolated_y)
      else
        obj_x, obj_y = camera:to_screen_position(object.x, object.y)
      end
      object:draw(obj_x, obj_y)
    end
end

local Tile = require "tile"

function game:draw_tiles()
  for _, tile in pairs(rects) do
    obj_x, obj_y = camera:to_screen_position(tile.x, tile.y)
    tile:draw(obj_x, obj_y)
    -- love.graphics.rectangle('fill', obj_x, obj_y, rec.width, rec.height)
  end
end

require "shaders"
function game:draw_all(dt)
  game:draw_backgrounds()
  game:draw_tiles()
  game:draw_player()
  game:draw_test_mode()
end

local rect = {
  x = 1000,
  y = 300,
  width = 200,
  height = 150,
}

function game:draw(dt)
  local mode = 'line'
  local is_collision = self.player:collide_bbox(rect.x, rect.y, rect.width, rect.height)
  if is_collision then
    local a = (frame_number*config.CAMERA_SHAKE.PERLIN*config.CAMERA_SHAKE.MAX_X) % 1000
    local x = samplePerlin(a/20.0, slope_1)
    local y = samplePerlin(a/20.0, slope_2)
    local formula = (x+1) / 2.0
    love.graphics.setColor(1, formula, formula)
    mode = 'line'
    self:activate_slow_motion(4)
  else
    self.slow_motion = false
    love.graphics.setColor(1, 1, 1)
    mode = 'fill'
  end
  local obj_x, obj_y = camera:to_screen_position(rect.x, rect.y)
  self:draw_all(dt)
  local background_color = {0/255, 64/255, 64/255, 1}
  love.graphics.setBackgroundColor(background_color)
  love.graphics.rectangle(mode, obj_x, obj_y, rect.width, rect.height)
end

return game
