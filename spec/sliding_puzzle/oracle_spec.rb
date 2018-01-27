require "spec_helper"

RSpec.describe SlidingPuzzle::Oracle do
  describe ".precompute" do
    let(:goal_state) do
      SlidingPuzzle.new(
        [1, 2],
        [3, 0],
      )
    end

    it "precomputes oracles for a goal state" do
      oracle = described_class.precompute(goal_state)
      expect(oracle).to be_a(described_class)
    end

    it "can print the queue size at each step" do
      expect { described_class.precompute(goal_state, debug: true) }
        .to output([
         "queue size: 1",
         "queue size: 2",
         "queue size: 2",
         "queue size: 2",
         "queue size: 2",
         "queue size: 2",
         "queue size: 2",
         "queue size: 2",
         "queue size: 2",
         "queue size: 2",
         "queue size: 2",
         "queue size: 1\n",
        ].join("\n")).to_stdout
    end
  end

  describe "#solve" do
    let(:goal_state) do
      SlidingPuzzle.new(
        [1, 2, 3],
        [4, 5, 0],
      )
    end

    subject { described_class.precompute(goal_state) }

    it "returns an array of moves to rearrange the puzzle to the goal state" do
      puzzle = SlidingPuzzle.new(
        [1, 0, 2],
        [4, 5, 3],
      )

      moves = subject.solve(puzzle)
      expect(moves).to eq [:left, :up]

      puzzle = SlidingPuzzle.new(
        [5, 0, 2],
        [1, 4, 3],
      )
      moves = subject.solve(puzzle)
      expect(moves).to eq [:right, :up, :left, :down, :left, :up]
    end

    it "does not break if the goal state is subsequently mutated" do
      puzzle = SlidingPuzzle.new(
        [1, 0, 2],
        [4, 5, 3],
      )

      moves = subject.solve(puzzle)
      expect(moves).to eq [:left, :up]

      goal_state.scramble!

      moves = subject.solve(puzzle)
      expect(moves).to eq [:left, :up]
    end

    it "returns an empty array for a solved puzzle" do
      moves = subject.solve(goal_state)
      expect(moves).to eq []
    end

    it "returns nil for an unsolvable puzzle" do
      unsolvable = SlidingPuzzle.new(
        [2, 1, 3],
        [4, 5, 0],
      )

      moves = subject.solve(unsolvable)
      expect(moves).to be_nil
    end
  end

  describe "#write / #read" do
    subject do
      goal_state = SlidingPuzzle.new(
        [1, 2],
        [3, 0],
      )

      described_class.precompute(goal_state)
    end

    it "marshals and unmarshals the oracle to a file" do
      file = Tempfile.new

      subject.write(file.path)
      oracle = described_class.read(file.path)

      puzzle = SlidingPuzzle.new(
        [1, 0],
        [3, 2],
      )

      moves = oracle.solve(puzzle)
      expect(moves).to eq [:up]
    end
  end
end
