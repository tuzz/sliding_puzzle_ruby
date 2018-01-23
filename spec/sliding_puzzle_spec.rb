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

  it "works for the 'Moves' example in the readme" do
    puzzle = SlidingPuzzle.new(
      [1, 2, 0],
      [3, 4, 5],
      [6, 7, 8],
    )

    expect(puzzle.moves).to eq [:right, :up]

    expect { puzzle.slide(:left) }.to raise_error(
      SlidingPuzzle::InvalidMoveError,
      "unable to slide left",
    )
  end

  it "works for the 'Scrambling' example in the readme" do
    puzzle = SlidingPuzzle.new(
      [1, 2, 0],
      [3, 4, 5],
      [6, 7, 8],
    )

    puzzle.scramble!

    expect(puzzle.tiles).not_to eq [
      [1, 2, 0],
      [3, 4, 5],
      [6, 7, 8],
    ]
  end
end
