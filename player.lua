require 'tools'
require 'config'
require 'character'

-- TODO: put this somewhere else someday
floor_y = CONFIG.RESOLUTION.HEIGHT

Player = {}
setmetatable(Player, {__index=Character})

function Player.new(x, y, vx, vy, scalex, scaley)
  player = {
    width=16, height=16,
    x=x, y=y,
    vx=vx, vy=vy,
    current_quad = mario_quad
  }
  setmetatable(player, {__index = Player})
  return player
end

function Player:update_speed()
  local vx = self.vx
  local vy = self.vy
  local acc = CONFIG.ACCR

  if love.keyboard.isDown(CONFIG.KEYS.RUN) then
      maxspeed = CONFIG.MAXSPEED_R
  else
      maxspeed = CONFIG.MAXSPEED_W
  end

  -- accelerate/decelerate character based on where player keyboard event (going left/right)
  local movement = "still"

  if love.keyboard.isDown(CONFIG.KEYS.RIGHT) then
      if not love.keyboard.isDown(CONFIG.KEYS.LEFT) then
          if vx < 0 then 
              movement = "decelerating"
          elseif vx >= 0 then
              movement = "accelerating"
          end
      end
  elseif love.keyboard.isDown(CONFIG.KEYS.LEFT) then
      if vx > 0 then
          movement = "decelerating"
      elseif vx <= 0 then
          movement = "accelerating"
      end
  end

  if movement == "decelerating" then
      vx = sign(vx) * (math.abs(vx) - CONFIG.DEC)
  elseif movement == "accelerating" then
      vx = sign(vx) * (math.abs(vx) + acc)
  elseif movement == "still" then
      vx = (math.abs(vx) - CONFIG.FRC) * sign(vx)
  end

  -- air dragging when player in the air 
  if vy < 0 and vy > -CONFIG.MAXJUMPSPEED and math.abs(vx) >= CONFIG.AIR_DRAG_CONST1 then 
    vx = vx * CONFIG.AIR_DRAG_CONST2 
  end

  -- jumping
  local jump_ok = self.jump_ok -- whether player pressing "jump" will trigger jumping
  local jump_flag = self.jump_flag -- whether player last jump was taken into account
  local is_on_floor = self:is_on_floor() 

  if love.keyboard.isDown(CONFIG.KEYS.JUMP) then
      if self.is_on_floor and jump_ok then
          jump_ok = false
          jump_flag = true
          vy = -CONFIG.JUMPSPEED
      end
  else
      if is_on_floor then
          jump_ok = true
      end

      if vy < 0 then
          if jump_flag == true then
              jump_flag = false
              if vy < -CONFIG.JUMPSPEED/2 then 
                  vy = -CONFIG.JUMPSPEED/2
              end
              if vy < -CONFIG.MAXJUMPSPEED then
                  vy = -CONFIG.MAXJUMPSPEED
              end
          end
      end
  end

  if not is_on_floor then
      vy = self.vy + CONFIG.GRAVITYSPEED
      vy = math.min(vy, 6)
  end

  self.vx = math.min(math.abs(vx), maxspeed) * sign(vx) -- make sure player does not go faster than "maxspeed"
  self.vy = vy
  self.jump_flag = jump_flag
  self.jump_ok = jump_ok
end

function Player:is_on_floor()
    return self.y + self.height >= floor_y
end

function Player:update()
  self:update_speed()
  self.x = self.x + self.vx
  self.y = self.y + self.vy

  if self.y + self.height >= floor_y then
    self.y = floor_y - self.height
  end
end
