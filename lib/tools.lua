function sign(x)
  return (x<0 and -1) or 1
end

function calculate_switch_rate(speed, min_rate, max_rate, max_speed)
  local space = max_rate - min_rate

  local switch_rate = max_rate - space * (math.abs(speed) / max_speed)
  switch_rate = math.floor(switch_rate)

  return switch_rate
end

LinkedList = {}

function LinkedList.new(max_length)
  local obj = {
    data = {},
    max_length=max_length
  }
  setmetatable(obj, {__index=LinkedList})
  return obj
end

function LinkedList:push(item)
  if next(self.data) == nil then
    print("empty")
  end
end

