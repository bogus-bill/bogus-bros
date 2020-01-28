
-- game = game or require "game"
-- require "game"

block_width, block_height = 512, 432
text_atlas = love.graphics.newImage('sprites/mario/marios.png')
background_atlas = love.graphics.newImage('sprites/background/SNES - Super Mario World - Backgrounds Animated.png')

local back_height_1 = 18
local back_height_2 = 18+block_height+6
local back_height_3 = 18+(block_height+6)*11

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
objects_atlas = love.graphics.newImage('sprites/objects/objects_atlas.png')
objects_atlas2 = love.graphics.newImage('sprites/objects/SMO_Power_Moon_Green.png')
mario_quad = love.graphics.newQuad(1, 10, 16, 24, mario_atlas:getDimensions())
mario_quad2 = love.graphics.newQuad(18, 10, 16, 24, mario_atlas:getDimensions())
mario_quad4 = love.graphics.newQuad(54, 10, 16, 24, mario_atlas:getDimensions())

mario_quads = { 
  still = love.graphics.newQuad(1, 10, 16, 24, mario_atlas:getDimensions()),
  walking = love.graphics.newQuad(18, 10, 16, 24, mario_atlas:getDimensions()),
}

still_mario_quad = love.graphics.newQuad(1, 10, 16, 24, mario_atlas:getDimensions()), mario_atlas
local walking_mario = new_sprite(love.graphics.newQuad(18, 10, 16, 24, mario_atlas:getDimensions()), mario_atlas)


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

walking_sprites = SpriteAnimation.new(sprite_set["mario"]["walking"])


hs_running_spriteset = {
  love.graphics.newQuad(103, 10, 16, 24, mario_atlas:getDimensions()),
  love.graphics.newQuad(120, 10, 16, 24, mario_atlas:getDimensions()),
  -- love.graphics.newQuad(1+16*9 + 9, 10, 16, 24, mario_atlas:getDimensions()),
}

hs_running_sprites = SpriteAnimation.new(hs_running_spriteset)

lookingup_mario_quad = love.graphics.newQuad(36, 10, 16, 24, mario_atlas:getDimensions())
lookingdown_mario_quad = love.graphics.newQuad(52, 10, 16, 24, mario_atlas:getDimensions())
jumping_mario_quad = love.graphics.newQuad(70, 10, 16, 24, mario_atlas:getDimensions())
falling_mario_quad = love.graphics.newQuad(88, 10, 16, 24, mario_atlas:getDimensions())
jumping_high_speed_mario_quad = love.graphics.newQuad(136, 10, 16, 24, mario_atlas:getDimensions())

