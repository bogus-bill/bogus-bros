local config = require "config"

local events = {}

function events:pushing_left()
  return love.keyboard.isDown(config.KEYS.LEFT)
end

function events:pushing_right()
  return love.keyboard.isDown(config.KEYS.RIGHT)
end

function events:pushing_up()
  return love.keyboard.isDown(config.KEYS.UP)
end

function events:pushing_down()
  return love.keyboard.isDown(config.KEYS.DOWN)
end

function events:pushing_run()
  return love.keyboard.isDown(config.KEYS.RUN)
end

function events:pushing_reset()
  return love.keyboard.isDown(config.KEYS.RESET)
end



return events