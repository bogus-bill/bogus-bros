require "sprites"

local level1 = {
    name        = "level 1",
    width       = 200,
    height      = 200,
    tile_lines  = {
        {x=20, width=300, y=5, img_data={quad=tile_floor1_quad}},
        {x=20, width=300, y=4, img_data={quad=tile_floor2_quad}},
        {x=20, width=300, y=3, img_data={quad=tile_floor2_quad}},
        {x=20, width=300, y=2, img_data={quad=tile_floor2_quad}},
        {x=20, width=300, y=1, img_data={quad=tile_floor2_quad}},
        {x=20, width=300, y=0, img_data={quad=tile_floor2_quad}},
    },
    misc = {
        {x=10, y=20, img_data={image=luna_all, scalex=0.2, scaley=0.2}}
    }
}


function generate_tiles(width, height)
    -- generate lines
    local max_height = 10
    local plateform_data = {min=3, max=10}

    local tile_lines = {}

    local x_range = 0,100

    for x=0, 10 do
        local line_top = math.floor(math.random() * max_height)
        for y=0, line_top do
            table.insert(
                tile_lines, 
                {width=3, y=y, img_data={quad=tile_floor2_quad}}
            )
        end
    end

    return tile_lines
end

function generate_misc(width, height)
    return {}
end

function generate_level()
    local level = {
        name="generated",
        width = 200,
        height = 200
    }
    level.tile_lines = generate_tiles(level.width, level.height)
    level.misc = {}

    return level
end

local gen_level = generate_level()

return {
    level1=gen_level
    -- level1=generate_level()
}
