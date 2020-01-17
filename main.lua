require 'tools'
require 'config'
require 'graphics'
require 'character'
require 'player'

-- Window configuration
flags = {}

love.window.setMode(CONFIG.RESOLUTION.WIDTH, CONFIG.RESOLUTION.HEIGHT, flags)

function love.load()
    player = Player.new(300, 700, 0, 0)
end

function love.update(dt)
    if love.keyboard.isDown(CONFIG.KEYS.RESET) then
        player.x = 300
        player.y = 700
    end
    if love.keyboard.isDown("j") then
        animated_background.quads = back2
    end
    if love.keyboard.isDown("k") then
        animated_background.quads = back3
    end
    player:update()
end

function love.draw()
    animated_background:draw(1, 1)
    player:draw()
end
