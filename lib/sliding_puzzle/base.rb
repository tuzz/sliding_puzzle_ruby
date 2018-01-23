class SlidingPuzzle
  def initialize(*tiles)
    self.tiles = flatten_tiles(tiles)
  end

  def slide!(direction)
  end

  def print
  end

  def tiles
    @tiles
  end

  def find(number)
    tiles.each.with_index do |numbers, row|
      numbers.each.with_index do |n, column|
        return [row, column] if n == number
      end
    end

    nil
  end

  private

  def flatten_tiles(tiles)
    if tiles[0].is_a?(Array) && tiles[0][0].is_a?(Array)
      tiles.flatten(1)
    else
      tiles
    end
  end

  attr_writer :tiles
end
