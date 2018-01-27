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

    def self.precompute_all(max_tiles: 8, directory: "oracles", debug: false)
      FileUtils.mkdir_p("oracles")

      1.upto(5) do |rows|
        1.upto(5) do |columns|
          number_of_tiles = rows * columns - 1
          next if number_of_tiles > max_tiles

          numbers = 1.upto(number_of_tiles).to_a

          0.upto(number_of_tiles) do |position|
            numbers_with_blank = numbers.dup.insert(position, 0)
            tiles = numbers_with_blank.each_slice(columns).to_a

            goal_state = SlidingPuzzle.new(tiles)
            path = "#{directory}/#{basename(goal_state)}.dat"

            print "Precomputing #{path}... " if debug

            oracle = precompute(goal_state)
            oracle.write(path)

            puts "Done." if debug
          end
        end
      end
    end

    def self.lookup(goal_state)
      filename = "#{basename(goal_state)}.dat"
      path = File.expand_path("#{__dir__}/../../oracles/#{filename}")

      read(path) if File.exist?(path)
    end

    def self.basename(puzzle)
      puzzle.tiles.map { |row| row.join(",") }.join(":")
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

    def write(path)
      data = Marshal.dump(self)
      gzip = Zlib::Deflate.deflate(data)

      File.open(path, "wb") { |f| f.write(gzip) }
    end

    def self.read(path)
      gzip = File.binread(path)
      data = Zlib::Inflate.inflate(gzip)

      Marshal.load(data)
    end

    private

    attr_accessor :lookup_table
  end
end
