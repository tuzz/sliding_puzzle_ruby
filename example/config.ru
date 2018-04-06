require "sliding_puzzle"

class MyApp
  GOAL = SlidingPuzzle.new(
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [9, 10, 11, 12],
    [13, 14, 15, 0],
  )

  def initialize
    @oracle = SlidingPuzzle.oracle(GOAL)
  end

  def call(env)
      @calls ||= 0
    @puzzle ||= SlidingPuzzle.new(
        [10, 1, 4, 5],
        [9, 2, 6, 8],
        [11, 3, 0, 15],
        [13, 14, 7, 12],
     )
    #moves = @oracle.solve(puzzle)
    moves = [
        :up,
        :up, # <-- ignored
        :right, :right, :down, :down, :down, :left, :up, :up, :left,
        :left, :down, :down, :right, :up, :right, :right, :down, :left, :left,
        :up, :right, :down, :right, :up, :left, :up, :left, :left, :down, :right,
        :up, :left, :down, :right, :right, :right, :up, :left, :left, :left,
        :down, :right, :right, :up, :right, :down, :left, :left, :left, :up,
        :up, :right, :right, :down, :left, :up, :right, :right, :down, :left,
        :up, :left, :down, :left, :up, :right, :right, :right, :down, :left,
        :left, :left, :up, :right, :down, :left, :up, :right, :down, :right,
        :right, :up, :left, :left, :left, :down, :right, :right, :right, :up,
        :left, :left, :left

    ]

    moves = moves[@calls..-1]
    @calls += 1

    render_json(moves)
  end

  private

  def parse_url(env)
    env
      .fetch("PATH_INFO")[1..-1]
      .split(":")
      .map { |p| p.split(",").map(&:to_i) }
  end

  def render_json(data)
    [200, { "Content-Type" => "application/json" }, [data.to_json]]
  end
end

use Rack::Static, urls: %w(/index.html /style.css /script.js), index: "index.html"
run MyApp.new
