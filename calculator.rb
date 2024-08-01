require_relative "delimiter"
require_relative "delimited_numbers"

class Calculator
  OPERATORS = { "*" => :* }
  OPERATORS.default = :+
  private_constant :OPERATORS

  class NegativeNumbersNotAllowedError < StandardError
    def initialize(numbers)
      super("negative numbers not allowed #{numbers.join(", ")}")
    end
  end

  def add(descriptor)
    string_scanner = StringScanner.new(descriptor)
    delimiter = Delimiter.new(string_scanner)
    numbers = DelimitedNumbers.new(string_scanner.rest, delimiter)
    operator = OPERATORS[delimiter.to_s]

    negative_numbers, positive_numbers = partitioned_numbers(numbers)
    if negative_numbers.any?
      raise NegativeNumbersNotAllowedError.new(negative_numbers)
    end

    filtered_positive_numbers =
      positive_numbers
        .reject do |number|
          number > 1000
        end

    if filtered_positive_numbers.any?
      filtered_positive_numbers
        .reduce do |memo, number|
          memo.public_send(operator, number)
        end
    else
      0
    end
  end

  private

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
      expect(calculator.add("1,5,3,9,42,109")).to eq(169)
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

    it "ignores numbers bigger than 1000" do
      expect(calculator.add("//;\n2;1001")).to eq(2)
    end

    it "multiplies the numbers if delimiter is star" do
      expect(calculator.add("//*\n1*2*8")).to eq(16)
    end
  end
end
