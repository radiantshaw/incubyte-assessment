require_relative "delimiter"
require "debug"

class DelimitedNumbers
  include Enumerable

  def initialize(string, delimiter)
    @string = string
    @delimiter = delimiter
  end

  def each(&block)
    @string
      .split(@delimiter.to_regex)
      .map(&:to_i)
      .each(&block)
  end
end

RSpec.describe DelimitedNumbers do
  let(:string_scanner) { StringScanner.new("//;\n1;-2;3;4;-5") }

  describe "#partition" do
    it "partitions numbers" do
      delimiter = Delimiter.new(string_scanner)
      delimited_numbers =
        DelimitedNumbers.new(
          string_scanner.rest, delimiter
        )

      negative, positive =
        delimited_numbers.partition do |number|
          number.negative?
        end

      expect(negative.length).to eq(2)
      expect(positive.length).to eq(3)

      expect(negative).to all(be_negative)
      expect(positive).to all(be_positive)
    end
  end
end