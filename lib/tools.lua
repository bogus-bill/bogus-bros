function sign(x)
  return (x<0 and -1) or 1
end

function calculate_switch_time(speed, min_rate, max_rate, max_speed)
  local diff = max_rate - min_rate
  local speed_ratio = math.abs(speed) / max_speed
  local result = max_rate - diff * speed_ratio

  return result
end

tools = {
  sign=sign, 
  calculate_switch_time=calculate_switch_time
}
return tools