require 'lib/tools'
require 'config'
require 'graphics'
local Player = require 'player'
local game = require 'game'

local window_options = CONFIG.WINDOWOPTIONS
local game_width, game_height = game:get_resolution()
local scale_width, scale_height

function love.load()
    player = Player.new(300, 700, 16*2, 24*2, 0, 0)
    love.window.setMode(game_width, game_height, window_options)
end

function love.update(dt)
    if love.keyboard.isDown(CONFIG.KEYS.RESET) then
        player.x = game_width / 2
        player.y = game_height / 2
    end

    if love.keyboard.isDown("j") then animated_background.quads = back2 end
    if love.keyboard.isDown("k") then animated_background.quads = back3 end
    if love.keyboard.isDown("o") then animated_background.x = (animated_background.x - 10) end
    if love.keyboard.isDown("p") then animated_background.x = (animated_background.x + 10) end
    
    -- player:update(dt)
end

function love.draw()
    love.graphics.scale(scale_width, scale_height)
    animated_background:draw()
    -- player:draw() 
end

function love.resize()
    local screen_width, screen_height = love.graphics.getDimensions()
    scale_width, scale_height = screen_width/game_width, screen_height/game_height
end

