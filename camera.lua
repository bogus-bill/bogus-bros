local config = require "config"

local Camera = {}

function Camera:follow_lazily(x, y, width, height)
  local object_centerx, object_centery = (x + width/2), (y + height/2)
  local ideal_x = object_centerx - self.game_width/2
  local ideal_y = object_centery - self.game_height/2

  self.x = self.x + (ideal_x - self.x) * (1.0-config.CAMERA_LAZY_FOLLOW["value"])
  self.y = self.y*0.90 + ideal_y*0.10

  self.x = math.max(0, self.x)
  self.x = math.min(self.x, 2000)
  self.y = math.min(self.y, 0)

  self.x = self.x
  self.y = self.y
end

function Camera:center_on(x, y, width, height)
  local object_center = (x + width/2)
  self.x = object_center - self.game_width/2
  self.y = (y + height/2) - self.game_height/2

  self.x = math.max(0, self.x)
  self.x = math.min(self.x, 2000)

  -- self.y = math.max(0, self.y)
  self.y = math.min(self.y, 0)
end

function Camera:to_screen_position(x, y)
  return x-self.x, y-self.y
end


function Camera:start_shake(time_shaking)
  self.is_shaking = true
  self.shake_timer = time_shaking
end

function Camera:update(frame_cnt)
  if self.is_shaking then
    local angle, offx, offy = shake_camera_perlin(frame_cnt)
    self.x = self.x + offx
    self.y = self.y + offy
    self.shake_timer = self.shake_timer - frame_cnt
    if self.shake_timer <= 0 then
      self.is_shaking = false
    end
  end
end

function Camera:new(x, y, game_width, game_height)
    local obj = {
        x=x,
        y=y,
        game_width=game_width,
        game_height=game_height
    }
    setmetatable(obj, {__index=Camera})
    return obj    
end

return Camera