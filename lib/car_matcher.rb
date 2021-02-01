# frozen_string_literal: true

class CarMatcher
  attr_reader :input

  def initialize(input)
    @input = input
  end

  def matched(target)
    cars_matchers(target).select(&:match?)
  end

  private

  def cars_matchers(target)
    search_params_variants.map { |input_variant| CarsMatcher.new(input_variant, target) }
  end

  def match?(target)
    cars_matchers(target).any?(&:match?)
  end

  def search_params_variants
    return [input] if input[:trim] == CarWrapper::BLANK

    variants_to_split_string(input.slice(:model, :trim).values.join(' ')).map do |parts|
      { make: input[:make], model: parts[0], trim: parts[1] }
    end
  end

  def variants_to_split_string(str)
    words = str.split(' ')
    words_number = words.size

    (0..(words_number - 1)).reduce([]) do |result, i|
      result << [
        words[0..(words_number - i - 1)].join(' '),
        words[(words_number - i)..].join(' ')
      ]
    end
  end
end
