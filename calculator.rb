class Calculator
  def add(string_of_numbers)
    string_of_numbers
      .split(",")
      .map(&:to_i)
      .reduce do |memo, number|
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
  end
end
