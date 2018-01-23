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
end
