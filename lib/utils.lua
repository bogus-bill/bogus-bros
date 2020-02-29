function to_cartesian(x, y, height)
--  from stupid upper-left corner coords to cartesian
    return x, height - y 
end

function to_upperleft(x, y, width, height)
    -- print(height - y)
    return x, height - y
end

-- -1             11                  0               
-- 0              10 = height
-- 1               9 = height - 1
-- 2               8
-- 3               7
-- 4               6
-- 5               5
-- 6               4
-- 7               3
-- 8               2               
-- 9               1
-- 10              0
-- 11             -1                 30



-- height = 10

-- 1 de upperleft = 9 de cartesian = height - 1
-- 1 de cartesian = 9 de upperleft = height - 1

