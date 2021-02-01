# frozen_string_literal: true

class CarsMatcher
  attr_reader :input, :target

  def initialize(input, target)
    @input = input
    @target = target
  end

  def match?
    %i[make model trim].all? { |key| field_match?(key) }
  end

  private

  def field_match?(key)
    prepared_target[key].match?(/^#{prepared_input[key]}/)
  end

  def prepared_target
    @prepared_target ||= CarWrapper.new(target).car_for_search
  end

  def prepared_input
    @prepared_input ||= CarWrapper.new(input).car_for_search
  end
end
