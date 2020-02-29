require 'lib/tools'

local config = require 'config'
local game = require 'game'
require 'shaders'

local window_options = config.WINDOWOPTIONS
local game_width, game_height = game:get_resolution()
local scale_width, scale_height

-- implementation of love.run with fixed timestep 
-- from excellent article https://gafferongames.com/post/fix_your_timestep
require 'love_run'

function love.load()
    love.window.setMode(game_width, game_height, window_options)
    game:init()
end

function love.update(dt)
    game:update(dt)
end

function love.draw(dt)
    love.graphics.scale(scale_width, scale_height)
    game:draw(dt)
end

function love.resize()
    local screen_width, screen_height = love.graphics.getDimensions()
    scale_width, scale_height = screen_width/game_width, screen_height/game_height
end

