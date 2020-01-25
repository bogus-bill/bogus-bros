
local game = require("game")

text_atlas = love.graphics.newImage('sprites/mario/marios.png')
background_atlas = love.graphics.newImage('sprites/background/SNES - Super Mario World - Backgrounds Animated.png')
atlas_dims = text_atlas:getDimensions()

block_width, block_height = game:get_resolution()
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
mario_quad2 = love.graphics.newQuad(18, 10, 16, 24, mario_atlas:getDimensions())
mario_quad3 = love.graphics.newQuad(36, 10, 16, 24, mario_atlas:getDimensions())
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
  quads={
    mario_quad,
    mario_quad2,
  },
  freq=10,
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

walking_sprites = SpriteAnimation.new(sprite_set["mario"]["walking"]["quads"])
