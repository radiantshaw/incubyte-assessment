class Calculator
  def add(string_of_numbers)
    string_of_numbers
      .split(",")
      .map(&:to_i)
      .reduce(0) do |memo, number|
        memo + number
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
  end
end
