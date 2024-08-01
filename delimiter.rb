class Delimiter
  REGEX = /\/\/(?<delimiter>.)\n/
  private_constant :REGEX

  def initialize(string_scanner)
    @delimiter_token = string_scanner.scan(REGEX)
  end

  def to_regex
    if extracted_delimiter_character
      /#{"\\" + extracted_delimiter_character}|\n/
    else
      /,|\n/
    end
  end

  def to_s
    extracted_delimiter_character
  end

  private

  def extracted_delimiter_character
    @extracted_delimiter_character ||=
      if @delimiter_token
        extracted_delimiter =
          @delimiter_token.match(REGEX) do |matched_data|
            matched_data["delimiter"]
          end

        extracted_delimiter
      else
        ","
      end
  end
end