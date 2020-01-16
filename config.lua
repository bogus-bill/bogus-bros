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
      WIDTH="1024",
      WIDTH="768"
  }
}

text_atlas = love.graphics.newImage('sprites/mario/marios.png')
atlas_dims = text_atlas:getDimensions()

mario_quad = love.graphics.newQuad(0, 0, 16, 16, text_atlas:getDimensions())

