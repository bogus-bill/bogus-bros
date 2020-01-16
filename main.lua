require 'tools'
require 'config'
require 'character'
require 'player'

function love.load()
    player = Player.new(0, 0, 0, 0)
end
 
function love.update(dt)
    if love.keyboard.isDown(CONFIG.KEYS.RESET) then
        player.x = 300
        player.y = 0
    end
    player:update()
end

function love.draw()
    player:draw()
end
