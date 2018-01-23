class SlidingPuzzle
  def initialize(*tiles)
    self.tiles = flatten_tiles(tiles)
    self.max_row = tiles.size - 1
    self.max_column = tiles.first.size - 1
  end

  def slide!(direction)
  end

  def print
  end

  def moves
    row, column = find(0)
    moves = []

    moves.push(:left) unless column == max_column
    moves.push(:right) unless column.zero?
    moves.push(:up) unless row == max_row
    moves.push(:down) unless row.zero?

    moves
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

  attr_accessor :max_row, :max_column
  attr_writer :tiles
end
