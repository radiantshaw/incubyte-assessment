class Calculator
  def add(descriptor)
    delimiter, numbers = parsed(descriptor)

    numbers
      .gsub("\n", ",")
      .split(delimiter)
      .map(&:to_i)
      .reduce(0) do |memo, number|
        memo + number
      end
  end

  private

  def parsed(descriptor)
    descriptor
      .match(/\A(?:\/\/(?<delimiter>.)\n)?(?<numbers>.*)\z/m)
      .then do |match_data|
        [match_data["delimiter"] || ",", match_data["numbers"]]
      end
  end
end

RSpec.describe Calculator do
  let(:calculator) { described_class.new }

  describe "#add" do
    it "adds numbers separated by comma" do
      expect(calculator.add("1,5")).to eq(6)
    end

    it "handles single number" do
      expect(calculator.add("1")).to eq(1)
    end

    it "handles empty string" do
      expect(calculator.add("")).to eq(0)
    end

    it "handles more than 2 numbers" do
      expect(calculator.add("1,5,3,9,42,1099")).to eq(1159)
    end

    it "handles new lines" do
      expect(calculator.add("1\n2,3")).to eq(6)
    end

    it "works with a custom delimiter" do
      expect(calculator.add("//;\n1;2")).to eq(3)
    end
  end
end
