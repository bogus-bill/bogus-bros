local game = {}

game.tiles = {
  width=32,
  height=27,
  pixel_width=16,
  pixel_height=16,
}

function game:get_resolution()
  return self.tiles.pixel_width*self.tiles.width, self.tiles.pixel_height*self.tiles.height
end

return game