require 'lib/tools'

local config = require "config"
local game = require "game"
local Drawable = require "lib/drawable"

local events = require "events"
local floor_x, floor_y = game:get_resolution()
local characters = {}

require "sprites"
local physics = require "lib/physics"

local Player = {}
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
    -- maxspeed_w = config.MAXSPEED_W,
    jumpspeed = config.JUMPSPEED,
    friction = config.FRC,
    time_on_maxspeed = 0,
    cnt_dt = 0,
    quad_time_passed = 0,
    bbox = physics.Bbox:new(x, y, width, height),
  }

  obj.jumping = {
      physically_possible=false,
      max_jumps=2,
      jumps_done=0,
      timer=0,
      time_between_jumps=0.5
  }

  setmetatable(obj, {__index = Player})

  obj:set_maxspeed_r(config.MAXSPEED_R)

  self = obj
  return obj
end

function Player:could_physically_jump()
    return true
end

function Player:can_jump()
    local jmp = self.jumping
    if not self:could_physically_jump() then return false end
    if jmp.jumps_done >= jmp.max_jumps then return false end
    if jmp.jumps_done > 0 then
        if jmp.timer >= jmp.time_between_jump then
            return false
        end
    end
    return false
end

function Player:collide_bbox(x, y, width, height)
    return self.bbox:collide_bbox(x, y, width, height)
end

function Player:apply_friction(vx, dt)
    if events.pushing_left() or events.pushing_right() then
        return vx
    end
    if self.friction*dt > math.abs(vx) then
        vx = 0
    else
        if self:is_on_floor() then
            vx = (math.abs(vx) - self.friction*dt) * sign(vx)
        else
            vx = (math.abs(vx) - self.friction*dt*0.5) * sign(vx)
        end
    end
    return vx
end

function Player:process_maxspeed()
    if events:pushing_run() and (events:pushing_left() or events:pushing_right()) then
        self.maxspeed = self.maxspeed_r
    end
    self.maxspeed = self.maxspeed_w
end

function Player:process_directions(vx)
  self.movement = "still"
  if events.pushing_right() then
    self.direction = "right"
    if not love.keyboard.isDown(config.KEYS.LEFT) then
        if vx < 0 then
            self.movement = "decelerating"
        elseif vx >= 0 then
            self.movement = "accelerating"
        end
    end
  elseif events.pushing_left() then
    self.direction = "left"
    if vx > 0 then
        self.movement = "decelerating"
    elseif vx <= 0 then
        self.movement = "accelerating"
    end
  elseif events.pushing_up() then
    self.looking_up = true
  elseif events.pushing_down() then
    self.looking_down = true
  end
end

function Player:process_acceleration_vx(vx, acc, dec, dt)
  self.acceleration_vx = 0
  if self.movement == "decelerating" then
    if self:is_on_floor() then
        self.acceleration_vx = sign(vx) * (math.abs(vx) - dec)
    else
        self.acceleration_vx = sign(vx) * (math.abs(vx) - dec*config.JUMPING_DEC)
    end
  elseif self.movement == "accelerating" then
      if math.abs(vx) < self.maxspeed then
        self.acceleration_vx = sign(vx) * (math.abs(vx) + acc)
      else
        self.acceleration_vx = self.maxspeed * sign(vx)
      end
  elseif self.movement == "still" then
    self.acceleration_vx = self:apply_friction(vx, dt)
  end
  print(self.acceleration_vx, "vxvx")
end

function Player:update_speed(dt)
  local acc = config.ACCR*dt
  local dec = config.DEC*dt

  self.looking_up, self.looking_down = false, false

  self:process_maxspeed()
  self:process_directions(self.vx)
  self:process_acceleration_vx(self.vx, acc, dec, dt)
  self:process_jump()
  self:process_gravity(dt)
  self:process_speed_limits_vy()

  self.vx = self.vx + self.acceleration_vx
end

function Player:process_speed_limits_vy()
  if self.vy < 0 then
    if self.jump_flag == true then
      self.vy = math.max(self.vy, -self.jumpspeed)
      self.vy = math.max(self.vy, -config.MAXJUMPSPEED)
    end
  end
end

function Player:process_gravity(dt)
  if not is_on_floor then
    self.vy = self.vy + config.GRAVITYSPEED*dt
    self.vy = math.min(self.vy, config.MAX_FALLING_SPEED)
  end
end

function Player:jump()
    self.vy = -self.jumpspeed*20
    self.jump_ok = false
    self.jump_flag = true
end

function Player:process_jump()
  if love.keyboard.isDown(config.KEYS.JUMP) then
    if self:is_on_floor() and self.jump_ok then
        self:jump()
    end
  else
    if self:is_on_floor() then
        self.jump_ok = true
    end
  end
end

function Player:apply_air_dragging()
    -- applied when above floor
    if (not self:is_on_floor())
         -- and vy > -config.MAXJUMPSPEED
         and math.abs(vx) >= config.AIR_DRAG_CONST1 then
     if self.is_high_speed_running then
         vx = vx * (0.99)
     else
         vx = vx * config.AIR_DRAG_CONST2
     end
  end
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

function Player:update_direction()
    if table.getn(self.statestack) > 1 then
        if self.direction ~= self.statestack[1].direction then
            self:switch_direction()
        end
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

-- return dy = y - y[last_frame]
function Player:get_y_distance()
    if table.getn(self.statestack) > 1 then
        return self.y - self.statestack[1].y
    end
    return 0
end

function Player:choose_falling_sprite()
    if self.is_high_speed_running then
        self.current_quad = jumping_high_speed_mario_quad
    else
        self.current_quad = falling_mario_quad
    end
end

function Player:choose_jumping_sprite()
    if self.is_high_speed_running then
        self.current_quad = jumping_high_speed_mario_quad
    else
        self.current_quad = jumping_mario_quad
    end
end

local speed_match = {
    walking=config.MAXSPEED_W,
    running=config.MAXSPEED_R,
    highspeed_running=config.MAXSPEED_HSR,
}

function Player:choose_walking_sprite(min_rate, max_rate, dt)
    local switch_time
    local sprite_speed = speed_match[self.sprite_state]
    switch_time = calculate_switch_time(dt, self.vx, min_rate, max_rate, sprite_speed)

    if self.quad_time_passed >= switch_time then
        self.quad_time_passed = 0
        if math.abs(self.vx) <= config.MAXSPEED_R then
            self.current_quad = walking_sprites:next()
        else
            self.current_quad = hs_running_sprites:next()
        end
    end
    self.quad_time_passed = self.quad_time_passed + dt
end

function Player:update_quad(dt, frame_cnt)
    local y_distance = self:get_y_distance()

    if self:is_falling() then
        self:choose_falling_sprite()
    elseif self:is_jumping() then
        self:choose_jumping_sprite()
    elseif self.looking_up then
        self.current_quad = lookingup_mario_quad
    elseif self.looking_down then
        self.current_quad = lookingdown_mario_quad
    elseif math.abs(self.vx) == 0 then
        self.current_quad = still_mario_quad
    elseif math.abs(self.vx) > 0 and y_distance == 0 then
        local min_rate, max_rate = 0.05, 0.1
        self:choose_walking_sprite(min_rate, max_rate, dt)
    end
end

function Player:set_maxspeed_r(value)
    self.maxspeed_r = value
    self.maxspeed_w = value * 0.7
end

function Player:process_high_speed_running(dt)
    -- high speed running means player has been running over MAXSPEED_R
    -- for a certain amount of frames thus we switch to high speed running
    -- print("frames on high", self.frames_on_maxspeed, game.frame_cnt, self.vx)
    if self:is_on_floor() then
        if math.abs(self.vx) >= config.MAXSPEED_R then
            self.time_on_maxspeed = self.time_on_maxspeed + dt
            if self.time_on_maxspeed >= config.TIME_UNTIL_HS_RUNNING then
                self.is_high_speed_running = true
                -- self.maxspeed_r = config.MAXSPEED_HSR
                self:set_maxspeed_r(config.MAXSPEED_HSR)
                self.jumpspeed = config.JUMPSPEED * 1.3
                self.friction = config.FRC
            end
        else
            -- self.maxspeed_r = config.MAXSPEED_R
            self:set_maxspeed_r(config.MAXSPEED_R)
            self.jumpspeed = config.JUMPSPEED
            self.time_on_maxspeed = 0
            self.is_high_speed_running= false
            self.friction = config.FRC
        end
    end
end

function Player:update(dt, frame_cnt)
  self.cnt_dt = self.cnt_dt + 1

  self:update_speed(dt)
  self:update_sprite_state()
  self:update_quad(dt, frame_cnt)
  self:update_direction()
  self:process_high_speed_running(dt)
  self.bbox:update_coordinates(self.x, self.y)

  local statestack_elem = {
      x=self.x,
      y=self.y,
      direction=self.direction,
      vx=self.vx,
      vy=self.vy,
      quad=self.current_quad,
      scalex=self.scalex,
      scaley=self.scaley,
      offsetx=self.offsetx,
      offsety=self.offsety,
  }

  table.insert(self.statestack, 1, statestack_elem)
  if table.getn(self.statestack) > config.STATESTACKMAXELEM then
      table.remove(self.statestack, 10)
  end

  if game:is_slow_motion() then
    config.DT_RATIO = 15
  else
    config.DT_RATIO = 60
  end

  self.x = self.x + self.vx*dt*config.DT_RATIO
  self.y = self.y + self.vy*dt*config.DT_RATIO

  if self.y + self.height >= floor_y then
    self.y = floor_y - self.height
  end
end

function Player:draw(x, y, angle)
    -- if not angle then angle = 0 end
    -- love.graphics.draw(self.texture_atlas, self.current_quad, self.x + self.offsetx + offsetx, self.y + self.offsety + offsety, angle, self.scalex, self.scaley)
    if config.DRAW_BBOXES then self.bbox:draw(x, y) end
    love.graphics.draw(self.texture_atlas, self.current_quad, x + self.offsetx, y + self.offsety, angle, self.scalex, self.scaley)
end

characters.Player = Player

Bobomb = {}

function Bobomb.init()
    local obj = {}
    setmetatable(obj, {__index=Drawable})
    return obj
end


return characters