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

  it "works for the 'Dimensions' example in the readme" do
    two_by_four = SlidingPuzzle.new(
      [1, 2, 3, 4],
      [5, 6, 7, 0],
    )

    two_by_four.slide!(:down)

    expect { two_by_four.print }.to output([
      [1, 2, 3, 0],
      [5, 6, 7, 4],
    ].map(&:inspect).join("\n")).to_stdout
  end

  pending "works for the 'Solving' example in the readme"
  pending "works for the 'Oracles' example in the readme"
  pending "works for the 'Impossible puzzles' example in the readme"

  it "works for the (simplified) 'Precomputing' example in the readme" do
    goal_state = SlidingPuzzle.new(
      [0, 1, 2],
      [3, 4, 5],
    )

    oracle = SlidingPuzzle.precompute(goal_state)

    file = Tempfile.new
    oracle.write(file.path)

    new_oracle = SlidingPuzzle.read(file.path)

    start_state = SlidingPuzzle.new(
      [1, 4, 2],
      [3, 0, 5],
    )

    moves = new_oracle.solve(start_state)
    expect(moves).to eq [:down, :right]
  end

  it "works for the 'Other methods' example in the readme" do
    puzzle = SlidingPuzzle.new(
      [1, 5,  2,  3],
      [4, 0,  6,  7],
      [8, 9, 10, 11],
    )

    expect(puzzle.get(0, 1)).to eq(5)
    expect(puzzle.find(5)).to eq [0, 1]

    puzzle.tiles[0][0] = 999
    expect(puzzle.tiles).to eq [
      [1, 5,  2,  3],
      [4, 0,  6,  7],
      [8, 9, 10, 11],
    ]

    clone = puzzle.clone
    puzzle.slide(:right)
    expect(clone.tiles).to eq [
      [1, 5,  2,  3],
      [4, 0,  6,  7],
      [8, 9, 10, 11],
    ]
  end
end
