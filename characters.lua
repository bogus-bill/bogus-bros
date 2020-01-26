require 'lib/tools'

local config = require "config"
local game = require "game"

Drawable = {}
function Drawable:draw()
  love.graphics.draw(self.texture_atlas, self.current_quad, self.x, self.y, 0, self.scalex, self.scaley)
end

local events = require "events"
local floor_x, floor_y = game:get_resolution()
local characters = {}

require "sprites"

Player = {}
setmetatable(Player, {__index=Drawable})

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
    statestack = {},
    is_high_speed_running = false,
    maxspeed_r = config.MAXSPEED_R,
    maxspeed_w = config.MAXSPEED_W,
    jumpspeed = config.JUMPSPEED,
    friction = config.FRC,
    frames_on_maxspeed = 0,
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

  self.looking_up, self.looking_down = false, false

  if events:pushing_run() and (events:pushing_left() or events:pushing_right()) then
      self.maxspeed = self.maxspeed_r
  else
      self.maxspeed = self.maxspeed_w
  end

  -- accelerate/decelerate character based on where Player keyboard event (going left/right)
  local movement = "still"

  if events.pushing_right() then
    self.direction = "right"
    if not love.keyboard.isDown(config.KEYS.LEFT) then
        if vx < 0 then 
            movement = "decelerating"
        elseif vx >= 0 then
            movement = "accelerating"
        end
    end
  elseif events.pushing_left() then
    self.direction = "left"
    if vx > 0 then
        movement = "decelerating"
    elseif vx <= 0 then
        movement = "accelerating"
    end
  elseif events.pushing_up() then
    self.looking_up = true
  elseif events.pushing_down() then
    self.looking_down = true
  end

  if movement == "decelerating" then
      vx = sign(vx) * (math.abs(vx) - config.DEC)
  elseif movement == "accelerating" then
      vx = sign(vx) * (math.abs(vx) + acc)
  end

--   vx = math.max(math.abs(vx) - self.friction, 0) * sign(vx)

    -- -- air dragging when above floor
    -- if vy > -config.MAXJUMPSPEED and math.abs(vx) >= config.AIR_DRAG_CONST1 then
    --     print("applying bullshit", game.frame_cnt) 
    --     if self.is_high_speed_running then 
    --         vx = vx * (0.99)
    --     else
    --         vx = vx * config.AIR_DRAG_CONST2
    --     end
    -- end
  -- jumping
  local jump_ok = self.jump_ok -- whether pressing "jump" will trigger jumping
  local jump_flag = self.jump_flag -- whether last jump was acknowledged
  local is_on_floor = self:is_on_floor()

  if love.keyboard.isDown(config.KEYS.JUMP) then
      if is_on_floor and jump_ok then
          jump_ok = false
          jump_flag = true
          vy = -self.jumpspeed
      end
  else
      if is_on_floor then
          jump_ok = true
      end

      if vy < 0 then
          if jump_flag == true then
              jump_flag = false
              if vy < -self.jumpspeed/2 then 
                  vy = -self.jumpspeed/2
              end
              if vy < -config.MAXJUMPSPEED then
                  vy = -config.MAXJUMPSPEED
              end
          end
      end
  end

  -- apply gravity force
  if not is_on_floor then
      vy = self.vy + config.GRAVITYSPEED
      vy = math.min(vy, 6)
  end

  self.vx = math.min(math.abs(vx), self.maxspeed) * sign(vx) -- make sure Player does not go faster than "maxspeed"
  self.vy = vy
  self.jump_flag = jump_flag
  self.jump_ok = jump_ok
end

function Player:is_on_floor()
    return self.y + self.height >= floor_y
end

function Player:update_sprite_state()
    local absvx = math.abs(self.vx)
    if self.looking_up == true then
        self.sprite_state = "looking_up"
    elseif absvx >= config.MAXSPEED_R then
        self.sprite_state = "highspeed_running"
    elseif absvx >= config.MAXSPEED_W then
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

function Player:is_jumping()
    return not self:is_on_floor() and self.vy <= 0
end

-- TODO: this integrates in some other way maybe falling from a plateforme without pushing jump
function Player:is_falling()
    return not self:is_on_floor() and self.vy > 0
end

function Player:update_quad(dt, frame_cnt)
    local y_distance = self.y - self.statestack[1].y

    if self:is_falling() then
        if self.is_high_speed_running then
            self.current_quad = jumping_high_speed_mario_quad
        else
            self.current_quad = falling_mario_quad
        end
    elseif self:is_jumping() then
        if self.is_high_speed_running then
            self.current_quad = jumping_high_speed_mario_quad
        else
            self.current_quad = jumping_mario_quad
        end
    elseif self.looking_up then
        self.current_quad = lookingup_mario_quad
    elseif self.looking_down then
        self.current_quad = lookingdown_mario_quad

    elseif math.abs(self.vx) == 0 then
        self.current_quad = still_mario_quad
    elseif math.abs(self.vx) > 0 and y_distance == 0 then
        local switch_rate
        local min_rate, max_rate = 5, 9
        if self.sprite_state == "walking" then
            switch_rate = calculate_switch_rate(self.vx, min_rate, max_rate, config.MAXSPEED_W)
        elseif self.sprite_state == "running" then
            switch_rate = calculate_switch_rate(self.vx, min_rate, max_rate, config.MAXSPEED_R)
        elseif self.sprite_state == "highspeed_running" then
            switch_rate = calculate_switch_rate(self.vx, min_rate-2, max_rate-4, config.MAXSPEED_HSR)
        end
        if frame_cnt % switch_rate == 0 then
            if math.abs(self.vx) <= config.MAXSPEED_R then
                self.current_quad = walking_sprites:next()
            else
                self.current_quad = hs_running_sprites:next()
            end
        end
    end
end
function Player:process_high_speed_running()
    -- high speed running means player has been running over MAXSPEED_R
    -- for a certain amount of frames thus we switch to high speed running
    -- print("frames on high", self.frames_on_maxspeed, game.frame_cnt, self.vx)
    if self:is_on_floor() then
        if math.abs(self.vx) >= config.MAXSPEED_R then
            self.frames_on_maxspeed = self.frames_on_maxspeed + 1
            if self.frames_on_maxspeed >= config.FRAMES_UNTIL_HS_RUNNING then
                self.is_high_speed_running = true
                self.maxspeed_r = config.MAXSPEED_HSR
                self.jumpspeed = config.JUMPSPEED_HSR
                self.friction = 0
            end
        else
            self.maxspeed_r = config.MAXSPEED_R
            self.jumpspeed = config.JUMPSPEED
            self.frames_on_maxspeed = 0
            self.is_high_speed_running= false
            self.friction = config.FRC
        end
    end
end

function Player:update(dt, frame_cnt)
  self:update_speed()
  self:update_sprite_state()
  self:update_quad(dt, frame_cnt)
  self:process_direction()

  self:process_high_speed_running()

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
end

function Player:draw(offsetx, offsety)
    love.graphics.draw(self.texture_atlas, self.current_quad, self.x + self.offsetx + offsetx, self.y + self.offsety + offsety, 0, self.scalex, self.scaley)
end

characters.Player = Player

return characters