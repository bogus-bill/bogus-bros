require "sprites"

Tile = {}

function Tile.new(x, y, width, height, img_data)
    local obj = {x=x, y=y, width=width, height=height,}
    if img_data.quad then
        obj.quad = img_data.quad
    end
    if img_data.image then
        obj.image = img_data.image
        obj.scalex = img_data.scalex
        obj.scaley = img_data.scaley
    end
    setmetatable(obj, {__index=Tile})
    return obj
end

function Tile:draw(x, y)
    if self.quad then
        draw_quad(tiles_atlas, self.quad, x, y)  
    elseif self.image then
        draw_image(self.image, x, y, self.scalex, self.scaley)
    end
end


function draw_image(image, x, y, scalex, scaley)
    return love.graphics.draw(image, x, y, 0, scalex, scaley)
end

function draw_quad(texture_atlas, quad, x, y, scalex, scaley)
    return love.graphics.draw(texture_atlas, quad, x, y, 0, scalex, scaley)
end

return Tile