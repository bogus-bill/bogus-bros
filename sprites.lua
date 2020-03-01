
-- game = game or require "game"
-- require "game"
love.graphics.setDefaultFilter("nearest", "nearest")
text_atlas =        love.graphics.newImage('sprites/mario/marios.png')
mario_atlas =       love.graphics.newImage('sprites/mario/SNES - Super Mario World - Mario_.png')
-- love.graphics.setDefaultFilter("linear", "linear")
tiles_atlas =       love.graphics.newImage('sprites/tiles/tiles2.png')
objects_atlas =     love.graphics.newImage('sprites/objects/luna1.png')
objects_atlas2 =    love.graphics.newImage('sprites/objects/SMO_Power_Moon_Green.png')
background_atlas =  love.graphics.newImage('sprites/background/SNES - Super Mario World - Backgrounds Animated.png')
luna_all =            love.graphics.newImage('sprites/objects/luna1.png')

block_width, block_height = 512, 432
local back_height_1 = 18
local back_height_2 = 18+block_height+6
local back_height_3 = 18+(block_height+6)*11
local back_height_5 = 16+(block_height+6)*10
local back_height_stars = 1770

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

back5 = {
  love.graphics.newQuad(7, back_height_5, block_width, block_height, background_atlas:getDimensions()),
  love.graphics.newQuad(520, back_height_5, block_width, block_height, background_atlas:getDimensions()),
  love.graphics.newQuad(1033, back_height_5, block_width, block_height, background_atlas:getDimensions()),
  love.graphics.newQuad(1546, back_height_5, block_width, block_height, background_atlas:getDimensions())
}

stars_background = {
  love.graphics.newQuad(7, back_height_stars, block_width, block_height, background_atlas:getDimensions()),
  love.graphics.newQuad(520, back_height_stars, block_width, block_height, background_atlas:getDimensions()),
  love.graphics.newQuad(1033, back_height_stars, block_width, block_height, background_atlas:getDimensions()),
  love.graphics.newQuad(1546, back_height_stars, block_width, block_height, background_atlas:getDimensions())
}

function new_sprite(quad, texture_atlas)
  local sprite = {}
  sprite["quad"] = love.graphics.newQuad(7, back_height_3, block_width, block_height, background_atlas:getDimensions())
  sprite["texture_atlas"] = texture_atlas
  return sprite
end

SpriteAnimation = {}

function SpriteAnimation.new(sprites)
  local obj = {
    sprites=sprites,
    ind=1,
    nb_sprites=table.getn(sprites),
  }
  obj["sprite"] = obj.sprites[obj["ind"]]
  setmetatable(obj, {__index = SpriteAnimation})
  return obj
end

function SpriteAnimation:next()
  self.ind = (self.ind + 1) % self.nb_sprites
  self.sprite = self.sprites[self.ind+1]
  return self.sprite
end

hs_running_spriteset = {
  love.graphics.newQuad(103, 10+1187, 16, 24, mario_atlas:getDimensions()),
  love.graphics.newQuad(120, 10+1187, 16, 24, mario_atlas:getDimensions()),
  -- love.graphics.newQuad(1+16*9 + 9, 10, 16, 24, mario_atlas:getDimensions()),
}

hs_running_sprites = SpriteAnimation.new(hs_running_spriteset)
still_mario_quad = love.graphics.newQuad(1, 10, 16, 24, mario_atlas:getDimensions())
lookingup_mario_quad = love.graphics.newQuad(35, 10, 16, 24, mario_atlas:getDimensions())
lookingdown_mario_quad = love.graphics.newQuad(52, 10, 16, 24, mario_atlas:getDimensions())
jumping_mario_quad = love.graphics.newQuad(69, 10, 16, 24, mario_atlas:getDimensions())
falling_mario_quad = love.graphics.newQuad(86, 10, 16, 24, mario_atlas:getDimensions())
jumping_high_speed_mario_quad = love.graphics.newQuad(137, 10, 16, 24, mario_atlas:getDimensions())
braking_mario_quad = love.graphics.newQuad(154, 10, 16, 24, mario_atlas:getDimensions())
facing_screen_mario_quad = love.graphics.newQuad(171, 10, 16, 24, mario_atlas:getDimensions())
backing_screen_mario_quad = love.graphics.newQuad(188, 10, 16, 24, mario_atlas:getDimensions())

still_mario_quad = love.graphics.newQuad(1, 10+1187, 16, 24, mario_atlas:getDimensions())
lookingup_mario_quad = love.graphics.newQuad(35, 10+1187, 16, 24, mario_atlas:getDimensions())
lookingdown_mario_quad = love.graphics.newQuad(52, 10+1187, 16, 24, mario_atlas:getDimensions())
jumping_mario_quad = love.graphics.newQuad(69, 10+1187, 16, 24, mario_atlas:getDimensions())
falling_mario_quad = love.graphics.newQuad(86, 10+1187, 16, 24, mario_atlas:getDimensions())
jumping_high_speed_mario_quad = love.graphics.newQuad(137, 10+1187, 16, 24, mario_atlas:getDimensions())
braking_mario_quad = love.graphics.newQuad(154, 10+1187, 16, 24, mario_atlas:getDimensions())
facing_screen_mario_quad = love.graphics.newQuad(171, 10+1187, 16, 24, mario_atlas:getDimensions())
backing_screen_mario_quad = love.graphics.newQuad(188, 10+1187, 16, 24, mario_atlas:getDimensions())

mario_quad =      love.graphics.newQuad(1, 10+1187, 16, 24, mario_atlas:getDimensions())
mario_quad2 =     love.graphics.newQuad(18, 10+1187, 16, 24, mario_atlas:getDimensions())
mario_quad4 =     love.graphics.newQuad(54, 10+1187, 16, 24, mario_atlas:getDimensions())

mario_quads = { 
  still = love.graphics.newQuad(1, 10+1187, 16, 24, mario_atlas:getDimensions()),
  walking = love.graphics.newQuad(18, 10+1187, 16, 24, mario_atlas:getDimensions()),
}

sprite_set = {}

sprite_set["mario"] = {}
sprite_set["mario"]["walking"] = {
  mario_quad,
  mario_quad2,
}
sprite_set["mario"]["still"] = {
  quads={
    still_mario_quad,
  },
}

walking_sprites = SpriteAnimation.new(sprite_set["mario"]["walking"])
tile_floor1_quad = love.graphics.newQuad(34, 102, 15, 15, tiles_atlas:getDimensions())
tile_floor2_quad = love.graphics.newQuad(34, 119, 15, 15, tiles_atlas:getDimensions())
luna1 =               love.graphics.newQuad(0, 0, 32, 32, luna_all:getDimensions())
