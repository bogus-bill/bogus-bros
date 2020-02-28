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
  AIR_DRAG_CONST1=0.125,
  AIR_DRAG_CONST2=0.96875,
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
  STATESTACKMAXELEM=10,
  DRAW_BBOXES=false,
  CAMERA_SHAKE={RANDOM=0.2, PERLIN=2.0, MAX_X=10.0, MAX_Y=10.0, MAX_ANGLE=0.1},
  CAMERA_LAZY_FOLLOW={value=0.94},
} 
config.ACCR = 0.16
config.DEC = config.ACCR*0.7
config.ACCW = config.ACCR 
config.JUMPING_DEC = config.DEC*1.5
config.JUMPSPEED = 15
config.MAXSPEED_W = 3                       -- max walking speed
config.MAXSPEED_R = config.MAXSPEED_W*1.5    -- max regular running speed
config.MAXSPEED_HSR = config.MAXSPEED_R*1.5  -- max high speed running speed
config.FRC = 0.05   -- friction force
config.GRAVITYSPEED = 0.7
-- config.MAXJUMPSPEED = 1.8
config.MAX_FALLING_SPEED = 15
-- CAMERATYPE choices are ["follow_lazily", "center_on"]
config.CAMERATYPE="follow_lazily"
-- TIME_UNTIL_HS_RUNNING: how many frames while runnig at MAXSPEED_R until reaching high speed running
config.TIME_UNTIL_HS_RUNNING=40    

return config
