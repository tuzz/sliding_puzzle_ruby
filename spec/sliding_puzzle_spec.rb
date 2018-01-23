require "spec_helper"

RSpec.describe SlidingPuzzle do
  it "works for the 'Usage' example in the readme" do
    puzzle = SlidingPuzzle.new(
      [1, 2, 0],
      [3, 4, 5],
      [6, 7, 8],
    )

    puzzle.slide!(:right)

    expect { puzzle.print }.to output([
      [1, 0, 2],
      [3, 4, 5],
      [6, 7, 8],
    ].map(&:inspect).join("\n")).to_stdout
  end
end
