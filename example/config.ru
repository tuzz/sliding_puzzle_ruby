require "sliding_puzzle"

class MyApp
  GOAL = SlidingPuzzle.new(
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 0],
  )

  def initialize
    @oracle = SlidingPuzzle.oracle(GOAL)
  end

  def call(env)
    tiles = parse_url(env)
    puzzle = SlidingPuzzle.new(tiles)
    moves = @oracle.solve(puzzle)

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
