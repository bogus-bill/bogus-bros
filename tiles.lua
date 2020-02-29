require "sprites"

Tile = {}

function Tile.draw(x, y, quad)
    -- obj_x, obj_y = camera:to_screen_position(x, y)
    love.graphics.draw(tiles_atlas, quad, x, y)  
end
  
-- function Tile:draw()
--     for _, rec in pairs(rects) do
--         obj_x, obj_y = camera:to_screen_position(rec.x, rec.y)
--         self:draw_tile(obj_x, obj_y, tile_floor1_quad)
--         -- love.graphics.rectangle('fill', obj_x, obj_y, rec.width, rec.height)
--     end
-- end