require "keys"

CONFIG = {
  ACCR=0.13,
  DEC=0.15,
  ACCW=0.7,
  MAXSPEED_W=1.4, 
  MAXSPEED_R=1.4*(12/7),
  FRC=0.044*(3/2),
  AIR_DRAG_CONST1=0.125,
  AIR_DRAG_CONST2=0.96875,
  JUMPSPEED=5.81, 
  GRAVITYSPEED=0.25,
  MAXJUMPSPEED=3.5,
  KEYS=KEYS,
  RESOLUTION={
      WIDTH=80*16,
      HEIGHT=32*16
  }
  -- RESOLUTION={
  --   WIDTH=1024,
  --   HEIGHT=864
  -- }
}

text_atlas = love.graphics.newImage('sprites/mario/marios.png')
background_atlas = love.graphics.newImage('sprites/background/SNES - Super Mario World - Backgrounds Animated.png')

atlas_dims = text_atlas:getDimensions()

mario_quad = love.graphics.newQuad(0, 0, 16, 16, text_atlas:getDimensions())

back_height_1 = 18
back_height_2 = 18+432+6
back_height_3 = 18+(432+6)*11

back1 = {
  love.graphics.newQuad(7, back_height_1, 512, 432, background_atlas:getDimensions()),
  love.graphics.newQuad(520, back_height_1, 512, 432, background_atlas:getDimensions()),
  love.graphics.newQuad(1033, back_height_1, 512, 432, background_atlas:getDimensions()),
  love.graphics.newQuad(1546, back_height_1, 512, 432, background_atlas:getDimensions())
}

back2 = {
  love.graphics.newQuad(7, back_height_2, 512, 432, background_atlas:getDimensions()),
  love.graphics.newQuad(520, back_height_2, 512, 432, background_atlas:getDimensions()),
  love.graphics.newQuad(1033, back_height_2, 512, 432, background_atlas:getDimensions()),
  love.graphics.newQuad(1546, back_height_2, 512, 432, background_atlas:getDimensions())
}

back3 = {
  love.graphics.newQuad(7, back_height_3, 512, 432, background_atlas:getDimensions()),
  love.graphics.newQuad(520, back_height_3, 512, 432, background_atlas:getDimensions()),
  love.graphics.newQuad(1033, back_height_3, 512, 432, background_atlas:getDimensions()),
  love.graphics.newQuad(1546, back_height_3, 512, 432, background_atlas:getDimensions())
}