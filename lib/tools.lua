function sign(x)
  return (x<0 and -1) or 1
end

function calculate_switch_time(dt, speed, min_time, max_time, max_speed)
  local diff = max_time - min_time
  local speed_ratio = math.abs(speed) / max_speed
  local result = max_time - diff * speed_ratio

  return result
end