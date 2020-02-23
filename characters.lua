local tools = require 'lib/tools'

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
    jumpspeed = config.JUMPSPEED,
    friction = config.FRC,
    frames_on_maxspeed = 0,
    cnt_dt = 0,
    quad_frames_elapsed = 0,
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

function Player:apply_friction(vx)
    if self.friction > math.abs(vx) then return 0 end
    if self.movement ~= "still" then
        return vx
    else
        if self:is_on_floor() then
            vx = (math.abs(vx) - self.friction) * sign(vx)
        else
            vx = (math.abs(vx) - self.friction*0.5) * sign(vx)
        end
    end
    return vx
end

function Player:calculate_maxspeed()
    if events:pushing_run() and (events:pushing_left() or events:pushing_right()) then
        self.maxspeed = self.maxspeed_r
    else
        self.maxspeed = self.maxspeed_w
    end
end

function Player:update_directions(vx)
  self.looking_up, self.looking_down = false, false
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

function Player:calculate_input_acceleration(vx, acc, dec)
  local sign_vx = sign(vx)

  if math.abs(vx) > self.maxspeed and self.movement ~= "still" then
    vx = sign_vx * self.maxspeed
  end
  if self.movement == "decelerating" then
    if not self:is_on_floor() then dec = config.JUMPING_DEC end
    vx = sign_vx * (math.abs(vx) - dec)
  elseif self.movement == "accelerating" then
    vx = sign_vx * (math.abs(vx) + acc)
  else
    vx = self:apply_friction(vx)
  end
  return vx
end

function Player:update_speed()
  local new_vx, new_vy = self.vx, self.vy
  print("vx is", self.vx)
  local acc, dec = config.ACCR, config.DEC

  new_vy = self:process_jump(self.vy)
  new_vy = self:process_gravity(new_vy)
--   new_vy = self:process_speed_limits_vy(new_vy)
  new_vx = self:calculate_input_acceleration(self.vx, acc, dec)

  self.vx, self.vy = new_vx, new_vy
end

function Player:process_speed_limits_vy(vy)
  if vy < 0 then
    if self.jump_flag == true then
      vy = math.max(vy, -self.jumpspeed)
      vy = math.max(vy, -config.MAXJUMPSPEED)
    end
  end
  return vy
end

function Player:process_gravity(vy)
  if not self:is_on_floor() then
    vy = vy + config.GRAVITYSPEED
    vy = math.min(vy, config.MAX_FALLING_SPEED)
  end
  return vy
end

function Player:jump(vy)
    vy = -self.jumpspeed
    self.jump_ok = false
    self.jump_flag = true
    return vy
end

function Player:process_jump(vy)
  if love.keyboard.isDown(config.KEYS.JUMP) then
    if self:is_on_floor() and self.jump_ok then
        vy = -self.jumpspeed
        self.jump_ok = false
        self.jump_flag = true
    end
  elseif self:is_on_floor() then
    self.jump_ok = true
  end
  return vy
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

function Player:process_sprite_state()
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

function Player:previous_direction()
    return self.statestack[1].direction
end

function Player:update_sprite_offset()
    if table.getn(self.statestack) > 1 then
        if self.direction ~= self:previous_direction() then
            self.scalex = -self.scalex
            self:process_offset() -- when scaling horizontally we need to adjust with a horizontal offset
        end
    end
end

function Player:is_jumping()
    return not self:is_on_floor() and self.vy <= 0
end

-- TODO: this integrates in some other way maybe falling from a plateforme without pushing jump
function Player:is_falling()
    return not self:is_on_floor() and self.vy > 0
end

function Player:get_flying_state()
    if self:is_on_floor() then return false end

    if self.vy <= 0 then
        return "jumping"
    else
        return "flying"
    end
end

-- return dy = y - y[last_frame]
function Player:calculate_df_y()
    if table.getn(self.statestack) > 1 then
        return self.y - self.statestack[1].y
    end
    return 0
end

local speed_map = {
    walking=config.MAXSPEED_W,
    running=config.MAXSPEED_R,
    highspeed_running=config.MAXSPEED_HSR,
}

function Player:calculate_walking_sprite(min_rate, max_rate)
    local sprite_speed = speed_map[self.sprite_state]
    local switch_time = tools.calculate_switch_time(self.vx, min_rate, max_rate, sprite_speed)
    local current_quad = self.current_quad

    if self.quad_frames_elapsed >= switch_time then
        self.quad_frames_elapsed = 0
        -- if math.abs(self.vx) <= config.MAXSPEED_R then
        if self.is_high_speed_running then
            current_quad = hs_running_sprites:next()
        else
            current_quad = walking_sprites:next()
        end
    end
    self.quad_frames_elapsed = self.quad_frames_elapsed + 1
    return current_quad
end

function Player:calculate_quad(frame_cnt)
    local y_distance = self:calculate_df_y()
    local flying_state =self:get_flying_state()
    local current_quad = self.current_quad

    if flying_state then
        if self.is_high_speed_running then
            return jumping_high_speed_mario_quad
        elseif flying_state == "jumping" then
            return jumping_mario_quad
        else
            return falling_mario_quad
        end
    elseif self.looking_up then
        return lookingup_mario_quad
    elseif self.looking_down then
        return lookingdown_mario_quad
    elseif math.abs(self.vx) == 0 then
        return still_mario_quad
    elseif math.abs(self.vx) > 0 and y_distance == 0 then
        local min_rate, max_rate = 4, 8
        return self:calculate_walking_sprite(min_rate, max_rate)
    end
    return current_quad
end

function Player:set_maxspeed_r(value, speedtype)
    self.maxspeed_r = value
    self.maxspeed_w = value * 0.7
end

function Player:process_high_speed_running()
    -- high speed running means player has been running over MAXSPEED_R
    -- for a certain amount of frames thus we switch to high speed running
    -- print("frames on high", self.frames_on_maxspeed, game.frame_cnt, self.vx)
    if self:is_on_floor() then
        if math.abs(self.vx) >= config.MAXSPEED_R then
            self.frames_on_maxspeed = self.frames_on_maxspeed + 1
            if self.frames_on_maxspeed >= config.TIME_UNTIL_HS_RUNNING then
                self.is_high_speed_running = true
                self:set_maxspeed_r(config.MAXSPEED_HSR)
                self.jumpspeed = config.JUMPSPEED * 1.3
                self.friction = config.FRC
            end
        else
            -- self.maxspeed_r = config.MAXSPEED_R
            self:set_maxspeed_r(config.MAXSPEED_R)
            self.jumpspeed = config.JUMPSPEED
            self.frames_on_maxspeed = 0
            self.is_high_speed_running= false
            self.friction = config.FRC
        end
    end
end

function Player:update_statestack(stackmax)
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
    if table.getn(self.statestack) > stackmax then
        table.remove(self.statestack, stackmax)
    end
end

function Player:update_sprite(frame_cnt)
    self:process_sprite_state()
    self.current_quad = self:calculate_quad(frame_cnt)
    self:update_sprite_offset()
end

function Player:update(dt, frame_cnt)
  print("direction", self.direction, self.movement)
  self.cnt_dt = self.cnt_dt + 1
  self:calculate_maxspeed()
  self:update_directions(self.vx)
  self:update_speed()
  self:update_sprite(frame_cnt)
  self:process_high_speed_running(dt)
  self.bbox:update_coordinates(self.x, self.y)

  self:update_statestack(config.STATESTACKMAXELEM)
-- TODO: remove that when possible
--   if game:is_slow_motion() then
--     DT_RATIO = 15
--   else
--     DT_RATIO = 60
--   end

  self.x = self.x + self.vx
  self.y = self.y + self.vy

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

return characters