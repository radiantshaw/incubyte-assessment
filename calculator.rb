class Calculator
  class NegativeNumbersNotAllowedError < StandardError
    def initialize(numbers)
      super("negative numbers not allowed #{numbers.join(", ")}")
    end
  end

  def add(descriptor)
    negative_numbers, positive_numbers = partitioned_numbers(parsed_numbers(descriptor))

    if negative_numbers.any?
      raise NegativeNumbersNotAllowedError.new(negative_numbers)
    end

    positive_numbers
      .reduce(0) do |memo, number|
        memo + number
      end
  end

  private

  def parsed_numbers(descriptor)
    descriptor
      .match(/\A(?:\/\/(?<delimiter>.)\n)?(?<numbers>.*)\z/m)
      .then do |match_data|
        converted_numbers(match_data["numbers"], match_data["delimiter"] || ",")
      end
  end

  def converted_numbers(numbers, delimiter)
    numbers
      .gsub("\n", ",")
      .split(delimiter)
      .map(&:to_i)
  end

  def partitioned_numbers(numbers)
    numbers
      .partition do |number|
        number.negative?
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

    it "throws error when negative numbers are encountered" do
      expect do
        calculator.add("//;\n-6;1;2;-42;50;-14")
      end.to raise_error(
        Calculator::NegativeNumbersNotAllowedError,
        "negative numbers not allowed -6, -42, -14"
      )
    end
  end
end
