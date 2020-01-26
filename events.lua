local config = require "config"

local events = {
  going_left = love.keyboard.isDown(config.KEYS.LEFT),
  pushing_right = love.keyboard.isDown(config.KEYS.RIGHT),
  looking_up = love.keyboard.isDown(config.KEYS.UP),
  looking_down = love.keyboard.isDown(config.KEYS.DOWN),
}

function events:is_going_left()
  return love.keyboard.isDown(config.KEYS.LEFT)
end

function events:is_going_right()
  return love.keyboard.isDown(config.KEYS.RIGHT)
end

function events:is_going_up()
  return love.keyboard.isDown(config.KEYS.UP)
end

function events:is_going_down()
  return love.keyboard.isDown(config.KEYS.DOWN)
end

return events