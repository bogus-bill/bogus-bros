require 'lib/tools'
local config = require 'config'
local graphics = require 'graphics'
local player = require 'player'
local game = require 'game'

local window_options = config.WINDOWOPTIONS
local game_width, game_height = game:get_resolution()

local animated_background = graphics.animated_background

frame_cnt = 0
local scale_width, scale_height

function love.load()
    player = Player:new(game_width/2, game_height/2, 16*2, 24*2, 0, 0)
    love.window.setMode(game_width, game_height, window_options)
end

function love.update(dt)
    if love.keyboard.isDown(config.KEYS.RESET) then
        player.x = game_width / 2
        player.y = game_height / 2
    end

    if love.keyboard.isDown("j") then animated_background.quads = back2 end
    if love.keyboard.isDown("k") then animated_background.quads = back3 end
    if love.keyboard.isDown("o") then animated_background.x = (animated_background.x - 10) end
    if love.keyboard.isDown("p") then animated_background.x = (animated_background.x + 10) end

    player:update(dt)

    -- love.graphics.setScissor(100, 100, 100, 100)
end

function love.draw()
    love.graphics.scale(scale_width, scale_height)
    animated_background:draw()
    player:draw()

end

function love.resize()
    local screen_width, screen_height = love.graphics.getDimensions()
    scale_width, scale_height = screen_width/game_width, screen_height/game_height
    
end

