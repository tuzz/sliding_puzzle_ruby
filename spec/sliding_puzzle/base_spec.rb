require "spec_helper"

RSpec.describe SlidingPuzzle do
  describe "#initialize" do
    it "can be initialized from array arguments" do
      subject = described_class.new(
        [1, 2, 0],
        [3, 4, 5],
        [6, 7, 8],
      )

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
end
