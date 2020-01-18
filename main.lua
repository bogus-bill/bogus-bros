require 'lib/tools'
require 'config'
require 'graphics'
require 'character'
require 'player'

local window_options = CONFIG.WINDOWOPTIONS
local game_width, game_height = CONFIG.GAMERESOLUTION.WIDTH, CONFIG.GAMERESOLUTION.HEIGHT
local screen_width, screen_height, scale_width, scale_height

function love.load()
    player = Player.new(300, 700, 16, 24, 0, 0, 1, 1)
    love.window.setMode(game_width, game_height, window_options)
end

function love.update(dt)
    if love.keyboard.isDown(CONFIG.KEYS.RESET) then
        player.x = 10
        player.y = 10
    end

    if love.keyboard.isDown("j") then animated_background.quads = back2 end
    if love.keyboard.isDown("k") then animated_background.quads = back3 end
    if love.keyboard.isDown("o") then animated_background.x = (animated_background.x - 10) end
    if love.keyboard.isDown("p") then animated_background.x = (animated_background.x + 10) end
    
    player:update(dt)
end

function love.draw()
    love.graphics.scale(scale_width, scale_height)
    animated_background:draw()
    player:draw() 
end

function love.resize()
    screen_width, screen_height = love.graphics.getDimensions()
    scale_width, scale_height = screen_width/game_width, screen_height/game_height
end