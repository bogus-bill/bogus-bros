require 'lib/tools'

local config = require 'config'
local game = require 'game'

local window_options = config.WINDOWOPTIONS
local game_width, game_height = game:get_resolution()
local scale_width, scale_height

-- implementation of love.run with fixed timestep 
-- from excellent article https://gafferongames.com/post/fix_your_timestep
require 'love_run'

function love.load()
    game:init()
    love.window.setMode(game_width, game_height, window_options)
end

function love.update(dt)
    -- if love.keyboard.isDown("j") then game.animated_background.quads = back2 end
    -- if love.keyboard.isDown("k") then game.animated_background.quads = back3 end
    -- if love.keyboard.isDown("o") then game.animated_background.x = (game.animated_background.x - 10) end
    -- if love.keyboard.isDown("p") then game.animated_background.x = (game.animated_background.x + 10) end
    game:update(dt)
end

function love.draw()
    love.graphics.scale(scale_width, scale_height)
    game:draw()
end

function love.resize()
    local screen_width, screen_height = love.graphics.getDimensions()
    scale_width, scale_height = screen_width/game_width, screen_height/game_height
end
