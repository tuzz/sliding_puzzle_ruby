require "spec_helper"

RSpec.describe SlidingPuzzle do
  subject do
    described_class.new(
      [1, 2, 0],
      [3, 4, 5],
      [6, 7, 8],
    )
  end

  describe "#initialize" do
    it "can be initialized from array arguments" do
      expect(subject.tiles).to eq [
        [1, 2, 0],
        [3, 4, 5],
        [6, 7, 8],
      ]
    end

    it "can be initialized from a nested array argument" do
      subject = described_class.new [
        [1, 2, 0],
        [3, 4, 5],
        [6, 7, 8],
      ]

      expect(subject.tiles).to eq [
        [1, 2, 0],
        [3, 4, 5],
        [6, 7, 8],
      ]
    end

    it "initializes correctly when there's a single row" do
      subject = described_class.new [1, 2, 0]
      expect(subject.tiles).to eq [[1, 2, 0]]

      subject = described_class.new [[1, 2, 0]]
      expect(subject.tiles).to eq [[1, 2, 0]]
    end

    it "raises an error if the puzzle isn't rectangular" do
      expect { described_class.new([1], [2, 0]) }
        .to raise_error(
          described_class::NotRectangularError,
          "puzzle must be rectangular",
        )
    end

    it "raises an error if the puzzle doesn't contain a blank" do
      expect { described_class.new([1], [2]) }
        .to raise_error(
          described_class::BlankError,
          "puzzle must contain a single blank",
        )
    end

    it "raises an error if the puzzle contains more than one blank" do
      expect { described_class.new([0], [0]) }
        .to raise_error(
          described_class::BlankError,
          "puzzle must contain a single blank",
        )
    end
  end

  describe "#slide!" do
    it "slides a tile in the direction of the blank" do
      subject = described_class.new(
        [1, 2, 0],
        [3, 4, 5],
        [6, 7, 8],
      )

      subject.slide!(:right)
      expect(subject.tiles).to eq [
        [1, 0, 2],
        [3, 4, 5],
        [6, 7, 8],
      ]

      subject.slide!(:up)
      expect(subject.tiles).to eq [
        [1, 4, 2],
        [3, 0, 5],
        [6, 7, 8],
      ]
    end

    it "raises an error if the move is invalid" do
      expect { subject.slide!(:down) }
        .to raise_error(
          described_class::InvalidMoveError,
          "unable to slide down",
        )
    end
  end

  describe "#slide" do
    it "does not mutate the existing puzzle and returns a new one" do
      puzzle = subject.slide(:right)

      expect(subject.tiles).to eq [
        [1, 2, 0],
        [3, 4, 5],
        [6, 7, 8],
      ]

      expect(puzzle.tiles).to eq [
        [1, 0, 2],
        [3, 4, 5],
        [6, 7, 8],
      ]
    end
  end

  describe "#clone" do
    it "returns a new instance of the puzzle and its tiles" do
      clone = subject.clone
      subject.slide(:right)

      expect(clone.tiles).to eq [
        [1, 2, 0],
        [3, 4, 5],
        [6, 7, 8],
      ]
    end
  end

  describe "#print" do
    it "prints the tiles to stdout" do
      expected = subject.tiles.map(&:inspect).join("\n")
      expect { subject.print }.to output(expected).to_stdout
    end
  end

  describe "#moves" do
    it "returns valid corner moves" do
      expect(subject.moves).to eq [:right, :up]
    end

    it "returns valid center moves" do
      subject = described_class.new(
        [1, 2, 3],
        [4, 0, 5],
        [6, 7, 8],
      )

      expect(subject.moves).to eq [:left, :right, :up, :down]
    end

    it "returns valid edge moves" do
      subject = described_class.new(
        [1, 2, 3],
        [4, 5, 0],
        [6, 7, 8],
      )

      expect(subject.moves).to eq [:right, :up, :down]
    end
  end

  describe "#tiles" do
    it "returns a clone of the puzzle's tiles" do
      subject.tiles[0][0] = 999
      expect(subject.tiles[0][0]).to eq(1)
    end
  end

  describe "#find" do
    it "finds the row and column of a number" do
      result = subject.find(1)
      expect(result).to eq [0, 0]

      result = subject.find(4)
      expect(result).to eq [1, 1]

      result = subject.find(5)
      expect(result).to eq [1, 2]
    end

    context "when the number doesn't exist" do
      it "returns nil" do
        result = subject.find(9)
        expect(result).to eq(nil)
      end
    end
  end

  describe "#scramble!" do
    it "scrambles the puzzle" do
      subject.scramble!

      expect(subject.tiles).not_to eq [
        [1, 2, 0],
        [3, 4, 5],
        [6, 7, 8],
      ]
    end

    it "can take an optional number of moves" do
      subject.scramble!(moves: 1)

      top_middle = subject.get(0, 1)
      top_right = subject.get(0, 2)
      middle_right = subject.get(1, 2)

      tiles = [top_middle, top_right, middle_right]

      expect([[0, 2, 5], [2, 5, 0]]).to include(tiles)
    end
  end

  describe "#scramble" do
    it "does not mutate the existing puzzle and returns a new one" do
      puzzle = subject.scramble

      expect(subject.tiles).to eq [
        [1, 2, 0],
        [3, 4, 5],
        [6, 7, 8],
      ]

      expect(puzzle.tiles).not_to eq [
        [1, 2, 0],
        [3, 4, 5],
        [6, 7, 8],
      ]
    end
  end

  describe "#get" do
    it "gets the tile at row, column" do
      expect(subject.get(0, 0)).to eq(1)
      expect(subject.get(1, 1)).to eq(4)
      expect(subject.get(2, 0)).to eq(6)
    end
  end

  describe "equality" do
    let(:identical_puzzle) do
      described_class.new(
        [1, 2, 0],
        [3, 4, 5],
        [6, 7, 8],
      )
    end

    let(:different_puzzle) do
      described_class.new(
        [1, 0, 2],
        [3, 4, 5],
        [6, 7, 8],
      )
    end

    it "is equal if the tiles are equal" do
      expect(subject).to eq(identical_puzzle)
      expect(identical_puzzle).to eq(subject)

      expect(subject).not_to eq(different_puzzle)
      expect(different_puzzle).not_to eq(subject)
    end

    it "defines equality for hash lookups" do
      hash = {}
      hash[subject] = true

      expect(hash[identical_puzzle]).to eq(true)
      expect(hash[different_puzzle]).to eq(nil)
    end
  end
end
