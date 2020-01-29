local physics = {}
local Bbox = {}

function physics.point_in_box(x1, y1, x2, y2, width2, height2)
  local cond1 = x1 <= x2 + width2 and x1 >= x2
  local cond2 = y1 <= y2 + height2 and y1 >= y2

  return cond1 and cond2
end

function physics.box2box_collide(x1, y1, width1, height1, x2, y2, width2, height2)
  local cond1 = physics.point_in_box(x1, y1, x2, y2, width2, height2)
  local cond2 = physics.point_in_box(x1 + width1, y1, x2, y2, width2, height2)
  local cond3 = physics.point_in_box(x1, y1 + height1, x2, y2, width2, height2)
  local cond4 = physics.point_in_box(x1+width1, y1 + height1, x2, y2, width2, height2)

  return cond1 or cond2 or cond3 or cond4
end

function Bbox:collide_bbox(x, y, width, height)
  return physics.box2box_collide(self.x, self.y, self.width, self.height,
                                 x, y, width, height)
end

function Bbox:new(x, y, width, height)
  local obj = {x=x, y=y, width=width, height=height}
  setmetatable(obj, {__index=Bbox})
  self = obj
  return obj
end

function Bbox:update_coordinates(x, y)
  self.x = x
  self.y = y
end

function Bbox:draw(x, y)
  love.graphics.rectangle('line', x, y, self.width, self.height)
end

local aa = Bbox:new(1, 2, 3, 4)

physics.Bbox = Bbox

return physics