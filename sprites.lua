text_atlas = love.graphics.newImage('sprites/mario/marios.png')
background_atlas = love.graphics.newImage('sprites/background/SNES - Super Mario World - Backgrounds Animated.png')
atlas_dims = text_atlas:getDimensions()



block_width=512
block_height=432
back_height_1 = 18
back_height_2 = 18+block_height+6
back_height_3 = 18+(block_height+6)*11

back1 = {
  love.graphics.newQuad(7, back_height_1, block_width, block_height, background_atlas:getDimensions()),
  love.graphics.newQuad(7+512+1, back_height_1, block_width, block_height, background_atlas:getDimensions()),
  love.graphics.newQuad(7+512*2+2, back_height_1, block_width, block_height, background_atlas:getDimensions()),
  love.graphics.newQuad(7+512*3+3, back_height_1, block_width, block_height, background_atlas:getDimensions()),
}
back2 = {
  love.graphics.newQuad(7, back_height_2, block_width, block_height, background_atlas:getDimensions()),
  love.graphics.newQuad(520, back_height_2, block_width, block_height, background_atlas:getDimensions()),
  love.graphics.newQuad(1033, back_height_2, block_width, block_height, background_atlas:getDimensions()),
  love.graphics.newQuad(1546, back_height_2, block_width, block_height, background_atlas:getDimensions())
}
back3 = {
  love.graphics.newQuad(7, back_height_3, block_width, block_height, background_atlas:getDimensions()),
  love.graphics.newQuad(520, back_height_3, block_width, block_height, background_atlas:getDimensions()),
  love.graphics.newQuad(1033, back_height_3, block_width, block_height, background_atlas:getDimensions()),
  love.graphics.newQuad(1546, back_height_3, block_width, block_height, background_atlas:getDimensions())
}

function new_sprite(quad, texture_atlas)
  local sprite = {}
  sprite["quad"] = love.graphics.newQuad(7, back_height_3, block_width, block_height, background_atlas:getDimensions())
  sprite["texture_atlas"] = texture_atlas
  return sprite
end

mario_atlas = love.graphics.newImage('sprites/mario/SNES - Super Mario World - Mario_.png')
mario_quad = love.graphics.newQuad(1, 10, 16, 24, mario_atlas:getDimensions())
mario_quads = { 
  still = love.graphics.newQuad(1, 10, 16, 24, mario_atlas:getDimensions()),
  walking = love.graphics.newQuad(18, 10, 16, 24, mario_atlas:getDimensions()),
}

local still_mario = new_sprite(love.graphics.newQuad(1, 10, 16, 24, mario_atlas:getDimensions()), mario_atlas)
local walking_mario = new_sprite(love.graphics.newQuad(18, 10, 16, 24, mario_atlas:getDimensions()), mario_atlas)

sprite_set = {}

sprite_set["mario"] = {}
sprite_set["mario"]["walking"] = {
  quads={
    -- still_mario,
    mario_quad,
    walking_mario,
  },
  freq=10,
}
sprite_set["mario"]["still"] = {
  quads={
    still_mario,
  },
}