mario = {
    x = 0,
    y = 0,
    vx = 0,
    vy = 0,
}

text_atlas = love.graphics.newImage("sprites/mario/marios.png")
mario_quad = love.graphics.newQuad(0, 0, 16, 16, text_atlas:getDimensions())

-- TileSet = function (a, setImage, quads, quads_w, quads_h)
-- 	a.setImage = setImage 
-- 	a.setWidth = setImage:getWidth()
-- 	a.setHeight = setImage:getHeight()
-- 	a.quads = quads
-- 	a.quads_w = quads_w
-- 	a.quads_h = quads_h
-- end)

-- Load some default values for our rectangle.
function love.load()
end
 
-- Increase the size of the rectangle every frame.
function love.update(dt)
end
 
-- Draw a coloured rectangle.
function love.draw()
    love.graphics.draw(text_atlas, mario_quad, 0, 0)
end
