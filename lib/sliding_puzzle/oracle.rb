class SlidingPuzzle
  class Oracle
    OPPOSITES = {
      left: :right,
      right: :left,
      up: :down,
      down: :up,
    }

    def self.precompute(goal_state, debug: false)
      goal_state = goal_state.clone

      queue = [goal_state]
      lookup_table = { goal_state => :goal }

      until queue.empty?
        puts "queue size: #{queue.size}" if debug
        puzzle = queue.shift

        puzzle.moves.each do |direction|
          next_puzzle = puzzle.slide(direction)

          unless lookup_table[next_puzzle]
            lookup_table[next_puzzle] = OPPOSITES[direction]
            queue.push(next_puzzle)
          end
        end
      end

      new(lookup_table)
    end

    def initialize(lookup_table)
      self.lookup_table = lookup_table
    end

    def solve(sliding_puzzle)
      moves = []
      next_puzzle = sliding_puzzle

      loop do
        direction = lookup_table[next_puzzle]

        return nil unless direction
        return moves if direction == :goal

        moves.push(direction)
        next_puzzle = next_puzzle.slide(direction)
      end
    end

    private

    attr_accessor :lookup_table
  end
end
