local KEYS={
  LEFT="left",
  RIGHT="right",
  DOWN="down",
  UP="up",
  RUN="lshift",
  JUMP="space",
  RESET="escape",
}

local config = {
  ACCR=0.13*300,
  DEC=0.02513*600,
  JUMPING_DEC=1.5,
  ACCW=0.7,
  MAXSPEED_W=1.4*2,              -- max walking speed
  MAXSPEED_R=1.4*2*2,          -- max regular running speed
  MAXSPEED_HSR=1.4*(12/7)*1.5*2, -- max high speed running speed
  TIME_UNTIL_HS_RUNNING=0.8,    -- how many frames while runnig at MAXSPEED_R until reaching high speed running
  FRC=0.015*600,
  AIR_DRAG_CONST1=0.125,
  AIR_DRAG_CONST2=0.96875,
  MAX_FALLING_SPEED=12,
  JUMPSPEED=5.81*1.2*2, 
  -- JUMPSPEED_HSR=5.81*1.2*1.5,
  GRAVITYSPEED=0.13*300,
  MAXJUMPSPEED=1.8,
  KEYS=KEYS,
  WINDOWOPTIONS = {
    vsync=true,
    resizable=true,
  },
  TILES={
    width=32,
    height=27,
    pixel_width=16,
    pixel_height=16,
  },
  DT_RATIO=60,
  STATESTACKMAXELEM=20,
  DRAW_BBOXES=true,
  CAMERA_SHAKE={RANDOM=0.2, PERLIN=1.0, MAX_X=10.0, MAX_Y=10.0, MAX_ANGLE=0.1},
  CAMERA_LAZY_FOLLOW={value=0.90}, 
}

return config
