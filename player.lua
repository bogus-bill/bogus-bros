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
    vx=vx, vy=vy,
    current_quad = mario_quad,
    texture_atlas= mario_atlas,
    scalex=2, scaley=2,
    sprite_set = sprite_set["mario"],
    sprite_ind = 1,
   }
  setmetatable(obj, {__index = Player})
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
      if not love.keyboard.isDown(config.KEYS.LEFT) then
        if vx < 0 then 
            movement = "decelerating"
        elseif vx >= 0 then
            movement = "accelerating"
        end
      end
  elseif love.keyboard.isDown(config.KEYS.LEFT) then
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
  elseif math.abs(vx) ~= 0 then
      vx = math.abs(math.abs(vx) - config.FRC) * sign(vx)
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
          jump_flag = true
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
    -- if math.abs(self.vx) == 0 then
    --     self.sprite_state = "still"
    -- else
    --     self.sprite_state = "walking"
    -- end
    self.sprite_state = "walking"
end

function Player:update_quad(dt)
    -- determine which sprite to draw
    local state_sprites = self.sprite_set[self.sprite_state]
    local nb_sprites = table.getn(state_sprites)

    -- know if we need to switch sprite
    print(frame_cnt, self.vx)
    if frame_cnt % 15 == 0 then
        self.sprite_ind = (self.sprite_ind + 1) % (nb_sprites + 1) 
        print("indice:", self.sprite_ind, "state:", self.sprite_state)
    end
    self.current_quad = self.sprite_set[self.sprite_state]["quads"][self.sprite_ind]
    self.current_quad = self.sprite_set["walking"]["quads"][1]
end

function Player:update(dt)
  self:update_speed()
  self:update_sprite()
--   self:update_quad(dt)
  self.x = self.x + self.vx
  self.y = self.y + self.vy

  if self.y + self.height >= floor_y then
    self.y = floor_y - self.height
  end
  frame_cnt = frame_cnt + 1
  print(self.x, self.y, game_height, game_width)
end

return Player