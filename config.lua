require "sprites" 

local KEYS={
  LEFT="left",
  RIGHT="right",
  DOWN="down",
  UP="up",
  RUN="lshift",
  JUMP="space",
  RESET="f",
}

local config = {
  ACCR=0.13 * 2,
  DEC=0.15,
  ACCW=0.7,
  MAXSPEED_W=1.4*2, 
  MAXSPEED_R=1.4*(12/7)*2,
  FRC=0.044*(3/2),
  AIR_DRAG_CONST1=0.125,
  AIR_DRAG_CONST2=0.96875,
  JUMPSPEED=5.81, 
  GRAVITYSPEED=0.25,
  MAXJUMPSPEED=3.5,
  KEYS=KEYS,
  WINDOWOPTIONS = {
    resizable=true,
    fullscreen=true,
  }
}

return config