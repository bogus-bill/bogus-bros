require 'lib/tools'

local config = require "config"
local character = require "character"
local game = require "game"

local game_width, game_height = game:get_resolution()
local floor_y = game_height

Player = {}
setmetatable(Player, {__index=character})

function Player:new(x, y, width, height, vx, vy)
  local obj = {
    width=width, height=height,
    x=x, y=y,
    offsetx=0, offsety=0,
    xs={}, ys={}, -- store n last positions
    vxs={}, vys={}, -- store n last positions
    vx=vx, vy=vy,
    direction="left",
    current_quad = mario_quad,
    texture_atlas= mario_atlas,
    scalex=2, scaley=2,
    sprite_set = sprite_set["mario"],
    sprite_ind = 1,
    statestack = {}
   }
  setmetatable(obj, {__index = Player})

  obj.statestack[1] = {
      x = obj.x,
      y = obj.y,
      vx = obj.vx,
      vy = obj.vy,
      direction = obj.direction,
    }
  obj.xs[1], obj.ys[1] = obj.x, obj.y
  obj.vxs[1], obj.vys[1] = obj.vx, obj.vy

  self = obj
  return obj
end

function Player:update_speed()
  local vx = self.vx
  local vy = self.vy
  local acc = config.ACCR

  if love.keyboard.isDown(config.KEYS.RUN) then
      maxspeed = config.MAXSPEED_R
  else
      maxspeed = config.MAXSPEED_W
  end

  -- accelerate/decelerate character based on where Player keyboard event (going left/right)
  local movement = "still"

  if love.keyboard.isDown(config.KEYS.RIGHT) then
    self.direction = "right"    
    if not love.keyboard.isDown(config.KEYS.LEFT) then
        if vx < 0 then 
            movement = "decelerating"
        elseif vx >= 0 then
            movement = "accelerating"
        end
      end
  elseif love.keyboard.isDown(config.KEYS.LEFT) then
    self.direction = "left"    
    if vx > 0 then
          movement = "decelerating"
      elseif vx <= 0 then
          movement = "accelerating"
      end
  end

  if movement == "decelerating" then
      vx = sign(vx) * (math.abs(vx) - config.DEC)
  elseif movement == "accelerating" then
      vx = sign(vx) * (math.abs(vx) + acc)
  elseif movement == "still" and math.abs(vx) ~= 0 then
      vx = math.max(math.abs(vx) - config.FRC, 0) * sign(vx)
  end

  -- air dragging when Player in the air 
  if vy > -config.MAXJUMPSPEED and math.abs(vx) >= config.AIR_DRAG_CONST1 then 
    vx = vx * config.AIR_DRAG_CONST2 
  end

  -- jumping
  local jump_ok = self.jump_ok -- whether Player pressing "jump" will trigger jumping
  local jump_flag = self.jump_flag -- whether Player last jump was taken into account
  local is_on_floor = self:is_on_floor() 

  if love.keyboard.isDown(config.KEYS.JUMP) then
      if self.is_on_floor and jump_ok then
          jump_ok = false
          jump_flag = trueœ
          vy = -config.JUMPSPEED
      end
  else
      if is_on_floor then
          jump_ok = true
      end

      if vy < 0 then
          if jump_flag == true then
              jump_flag = false
              if vy < -config.JUMPSPEED/2 then 
                  vy = -config.JUMPSPEED/2
              end
              if vy < -config.MAXJUMPSPEED then
                  vy = -config.MAXJUMPSPEED
              end
          end
      end
  end

  if not is_on_floor then
      vy = self.vy + config.GRAVITYSPEED
      vy = math.min(vy, 6)
  end

  self.vx = math.min(math.abs(vx), maxspeed) * sign(vx) -- make sure Player does not go faster than "maxspeed"
  self.vy = vy
  self.jump_flag = jump_flag
  self.jump_ok = jump_ok
end

function Player:is_on_floor()
    return self.y + self.height >= floor_y
end

function Player:update_sprite()
    absvx = math.abs(self.vx) 
    if absvx >= config.MAXSPEED_W then 
        self.sprite_state = "running"
    elseif absvx > 0 then
        self.sprite_state = "walking"
    else
        self.sprite_state = "still"
    end
end

function Player:process_offset()
    if self.direction == "left" then
        self.offsetx = 0
    else
        self.offsetx = self.width
    end
end

function Player:process_direction()
    if self.direction ~= self.statestack[1].direction then
        self:switch_direction()
    end
end

function Player:switch_direction()
    self.scalex = -self.scalex
    self:process_offset() -- when scaling horizontally we need to adjust with a horizontal offset
end

function Player:update_quad(dt)
    local min_rate, max_rate = 7, 20
    local y_distance = self.y - self.statestack[1].y
   
    if math.abs(self.vx) == 0 then
        self.current_quad = still_mario_quad
    elseif math.abs(self.vx) > 0 and y_distance == 0 then
        local switch_rate
        if self.movement == "walking" then
            switch_rate = calculate_switch_rate(self.vx, min_rate, max_rate, config.MAXSPEED_W)
        else
            switch_rate = calculate_switch_rate(self.vx, min_rate, max_rate, config.MAXSPEED_R)
        end
        print("swtich rate", switch_rate)
        print("swtich rate", switch_rate)
        if frame_cnt % switch_rate == 0 then
            self.current_quad = walking_sprites:next()
        end
    end
end

function Player:update(dt)
  self:update_speed()
  self:update_sprite()
  self:update_quad(dt)
  self:process_direction()

  self.statestack[1].direction = self.direction
  self.statestack[1].x = self.x
  self.statestack[1].y = self.y
  self.xs[1] = self.x
  self.ys[1] = self.y
  self.x = self.x + self.vx
  self.y = self.y + self.vy

  if self.y + self.height >= floor_y then
    self.y = floor_y - self.height
  end
  frame_cnt = frame_cnt + 1
end

function Player:draw()
    love.graphics.draw(self.texture_atlas, self.current_quad, self.x + self.offsetx, self.y + self.offsety, 0, self.scalex, self.scaley)
end

return Player
