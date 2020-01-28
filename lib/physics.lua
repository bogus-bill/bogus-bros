physics = {}


function point_in_box(x1, y1, x2, y2, width2, height2)
  local cond1 = x1 <= x2 + width2 and x1 >= x2
  local cond2 = y1 <= y2 + height2 and y1 >= y2

  return cond1 and cond2
end

function box2box_collide(x1, y1, width1, height1, x2, y2, width2, height2)
  local cond1 = point_in_box(x1, y1, x2, y2, width2, height2)
  local cond2 = point_in_box(x1+width1, y1, x2, y2, width2, height2)
  local cond3 = point_in_box(x1, y1+height1, x2, y2, width2, height2)
  local cond4 = point_in_box(x1+width1, y1+height1, x2, y2, width2, height2)

  return cond1 or cond2 or cond3 or cond4
end


CollisionBox = {}

function CollisionBox.new(x, y, width, height)
  obj = {x=x, y=y, width=width, heigt=height}
  return obj
end

Bbox = {}

function Bbox:collide_bbox(bbox)
  return box2box_collide(self.x, self.y, self.width, self.height,
                         bbox.x, bbox.y, bbox.width, bbox.height)
end

                         


-- return CollisionBox:is_colliding_with(box):

-- function box2box_collide(x1, y1, width1, height1, x2, y2, width2, height2)
--   if (x1 + width1 < x2) or
--      (x1 >= x2 + width2) or
--      (y1 + height1) > (y2 + height2) or
--      (y1 + height1 ) <= y2 then
--      return false
--   end
--   return true
-- end

