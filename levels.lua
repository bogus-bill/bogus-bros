require "sprites"

level1 = {
    name        = "level 1",
    width       = 200,
    height      = 200,
    tile_lines  = {
        {y=3, quad=tile_floor1_quad},
        {y=2, quad=tile_floor2_quad},
        {y=1, quad=tile_floor2_quad},
    },
    misc = {
        {x=5, y=5, quad=luna1}
    }
}

return {
    level1=level1
}
