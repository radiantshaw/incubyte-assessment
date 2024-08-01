class Descriptor
  OPERATOR_MAPPING = {
    ";" => :+,
    "*" => :*
  }

  private_constant :OPERATOR_MAPPING

  def initialize(descriptor)
    @descriptor = descriptor
  end

  def operator
    parse
    @operator || :+
  end

  def numbers
    parse
    @numbers
  end

  private

  def parse
    @numbers = @descriptor
      .match(/\A(?:\/\/(?<delimiter>.)\n)?(?<numbers>.*)\z/m)
      .then do |match_data|
        @operator = OPERATOR_MAPPING[match_data["delimiter"]]
        converted_numbers(match_data["numbers"], match_data["delimiter"] || ",")
      end.reject do |number|
        number > 1000
      end
  end

  def converted_numbers(numbers, delimiter)
    numbers
      .gsub("\n", ",")
      .split(delimiter)
      .map(&:to_i)
  end
end
