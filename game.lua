local graphics = graphics or require "graphics"
local events = events or require "events"
local config = config or require "config"
local objects = require "objects"
local physics = require "lib/physics"
local Drawable = require "lib/drawable"

local game = {}

game.tiles = config.TILES

game.frame_cnt = 1
game.animated_background = graphics.animated_background

require "effects"

local throwables = {}

local Rect = {
  x=0,
  y=0,
  width = 5,
  height = 5,
}

function Rect.new(x, y)
  local obj = {x=x, y=y}
  setmetatable(obj, {__index=Rect})
  return obj
end

function Rect:draw()
  love.graphics.rectangle(self.x, self.y, self.width, self.height)
end

function Rect:update()
  -- self.x = self.x + 10
  -- self.y = self.y + 10
end

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
  self.slow_motion = false

  self:throw_rectangle(rect)

end

function game:add_key_control(key, value, step)
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
  config.GRAVITYSPEED = game:add_key_control("u", config.GRAVITYSPEED, 0.1)
  config.DEC = game:add_key_control("i", config.DEC, 0.2)
  config.ACCR = game:add_key_control("o", config.ACCR, 0.1)
  config.JUMPSPEED = game:add_key_control("p", config.JUMPSPEED, 0.01)
  config.FRC = game:add_key_control("j", config.FRC, 0.2)
  config.MAXSPEED_R = game:add_key_control("k", config.MAXSPEED_R, 0.1)
  config.CAMERA_SHAKE["PERLIN"] = game:add_key_control("l", config.CAMERA_SHAKE["PERLIN"], 0.01)
  config.CAMERA_LAZY_FOLLOW["value"] = game:add_key_control("g", config.CAMERA_LAZY_FOLLOW["value"], 0.001)
  config.CAMERA_SHAKE.MAX_X = game:add_key_control("f", config.CAMERA_SHAKE.MAX_X, 0.5)
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
  love.graphics.print("camera lazy follow g"                                 ,0,   340-200)
  love.graphics.print('camera shake MAX_X f'                                 ,0,   360-200)
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
  
end

camera = {
  x = 0,
  y = 0,
}

function game:is_slow_motion()
  return self.slow_motion
end

function camera:follow_lazily(x, y, width, height)
  local object_centerx, object_centery = (x + width/2), (y + height/2)
  local ideal_x = object_centerx - game_width/2
  local ideal_y = object_centery - game_height/2

  self.x = self.x + (ideal_x - self.x) * (1.0-config.CAMERA_LAZY_FOLLOW["value"])
  -- self.x = self.x*config.CAMERA_LAZY_FOLLOW["value"] + ideal_x*(1.0-config.CAMERA_LAZY_FOLLOW["value"])
  self.y = self.y*0.90 + ideal_y*0.10

  self.x = math.max(0, self.x)
  self.x = math.min(self.x, 2000)
  self.y = math.min(self.y, 0)

  self.x = self.x
  self.y = self.y
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

function camera:to_screen_position(x, y)
  return x-self.x, y-self.y
end

game.ennemies = {}
game.effects = {}

local frame_number = 0
local angle = 0

function camera:start_shake(time_shaking)
  self.is_shaking = true
  self.shake_timer = time_shaking
end

function camera:update(frame_cnt)
  if self.is_shaking then
    angle, offx, offy = shake_camera_perlin(frame_cnt)
    self.x = self.x + offx
    self.y = self.y + offy
    self.shake_timer = self.shake_timer - frame_cnt
    if self.shake_timer <= 0 then
      self.is_shaking = false
    end
  end
end

function game:draw_all(dt)
  -- frame_number = frame_number + 1
  camera:update(self.frame_cnt)
  -- -- print(self.frame_cnt)
  -- if self:is_slow_motion() then
  --   frame_number = frame_number + 1
  --   angle, offx, offy = shake_camera_perlin(frame_number)
  --   -- angle, offx, offy = shake_camera(frame_number)
  --   camera.x = camera.x + offx
  --   camera.y = camera.y + offy
  -- end

  local drawables = {self.animated_background, self.player}
  
  for _, object in pairs(drawables) do
      -- local obj_x, obj_y
      -- modulo_reste = self.frame_cnt % SLOWMOTION_STEP - 1
      -- if object.statestack then
        -- print(object.x, object.y, object.statestack)
        -- print("stack is", object.statestack[1])
        -- interpolated_x = interpolate(object.statestack[1].x, object.x, SLOWMOTION_STEP, modulo_reste) 
        -- interpolated_y = interpolate(object.statestack[1].y, object.y, SLOWMOTION_STEP, modulo_reste) 
        
      --   obj_x, obj_y = camera:to_screen_position(interpolated_x, interpolated_y)
      --   obj_x2, obj_y2 = camera:to_screen_position(
      --     object.statestack[1].x, 
      --     object.statestack[1].y
      --   )
      --   obj_x3, obj_y3 = camera:to_screen_position(object.x, object.y)
      --   -- object:draw(obj_x, obj_y, angle)
      --   print(object.y, object.statestack[1].y, interpolated_y)
      --   object:draw(obj_x, obj_y, angle)
      --   -- object:draw(obj_x3, obj_y3, angle)
      -- else
      --   obj_x, obj_y = camera:to_screen_position(object.x, object.y)
      --   object:draw(obj_x, obj_y, angle)
      -- end
      if object.statestack and table.getn(object.statestack) > 0 and object.interpolated_x then
        obj_x, obj_y = camera:to_screen_position(object.interpolated_x, object.interpolated_y)
        -- print(object.statestack[1].y, object.y, object.interpolated_y)
      else
        obj_x, obj_y = camera:to_screen_position(object.x, object.y)
      end
      object:draw(obj_x, obj_y, angle)
  end
  game:update_test_mode()
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
    self.slow_motion = true
  else
    love.graphics.setColor(1, 1, 1)
    self.slow_motion = false
    mode = 'fill'
  end
  local obj_x, obj_y = camera:to_screen_position(rect.x, rect.y)
  self:draw_all(dt)
  love.graphics.rectangle(mode, obj_x, obj_y, rect.width, rect.height, angle)

end

return game