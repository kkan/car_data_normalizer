# frozen_string_literal: true

class CarWrapper
  BLANK = 'blank'

  def initialize(input)
    @car = input
  end

  def car_for_search
    @car_for_search ||= prepare_hash(@car)
  end

  def blank?(field)
    @car[field] == BLANK
  end

  private

  def prepare_hash(hash)
    hash.transform_values { |value| prepare_string(value) }.compact
  end

  def prepare_string(str)
    return nil if str == BLANK

    str.to_s.strip.gsub(/\s+/, ' ').downcase.presence
  end
end
