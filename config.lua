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
  ACCR=0.13 * 2.5,
  DEC=0.15*3,
  ACCW=0.7,
  MAXSPEED_W=1.4*2,              -- max walking speed
  MAXSPEED_R=1.4*2*1.6,       -- max regular running speed
  MAXSPEED_HSR=1.4*(12/7)*1.5*2, -- max high speed running speed
  FRAMES_UNTIL_HS_RUNNING=45,    -- how many frames while runnig at MAXSPEED_R until reaching high speed running
  FRC=0.033,
  AIR_DRAG_CONST1=0.125,
  AIR_DRAG_CONST2=0.96875,
  JUMPSPEED=5.81*1.2, 
  JUMPSPEED_HSR=5.81*1.2*1.5,
  GRAVITYSPEED=0.25*1.2,
  MAXJUMPSPEED=3.5,
  KEYS=KEYS,
  WINDOWOPTIONS = {
    resizable=true,
  },
  TILES={
    width=32,
    height=27,
    pixel_width=16,
    pixel_height=16,
  },
  STATESTACKMAXELEM=50,
}

return config