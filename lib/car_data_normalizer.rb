# frozen_string_literal: true

class CarDataNormalizer
  DATA_KEYS = { make: :makes, model: :models, trim: :trims }.freeze

  def initialize(car_input)
    @car_input = car_input
  end

  def process
    return @car_input if search_params.values_at(:make, :model).all?(&:blank?)

    @car_input.merge(find_car_data).tap { |result| replace_blanks(result) }
  end

  private

  def find_car_data
    different_inputs_results = aggregate_possible_variants

    if different_inputs_results.size == 1
      extract_from_result(different_inputs_results.first).compact
    elsif different_inputs_results.size.zero?
      additional_search.compact
    end
  end

  def replace_blanks(result)
    DATA_KEYS.each_key { |key| result[key] = nil if car_wrapper.blank?(key) }
  end

  def aggregate_possible_variants
    make_query = search_params[:make]
    model_query = search_params[:model].to_s.split(' ').first.presence

    results = {}

    trims_relation = Trim.by_make_and_model(make_query: make_query, model_query: model_query)
    trims_relation.each do |trim|
      car_matcher.matched(trim.car_hash).each { |cars_matcher| add_data_to_results(cars_matcher, results) }
    end

    results
  end

  def extract_from_result(result_for_different_inputs)
    params, collections = result_for_different_inputs

    {}.tap do |result|
      DATA_KEYS.each_pair do |key, plural_key|
        result[key] = find_entry(params[key], collections[plural_key]) || params[key].presence
      end
    end
  end

  def additional_search
    make_query, model_query = search_params.values_at(:make, :model)
    trims_relation = Trim.by_make_and_model(make_query: make_query, model_query: model_query)

    make = find_entry(make_query, trims_relation.map(&:make_title))
    model = find_entry(model_query, trims_relation.map(&:model_title))
    make ||= find_entry(make_query, Make.matched_titles(make_query))

    { make: make, model: model }.compact
  end

  def add_data_to_results(cars_matcher, results)
    results[cars_matcher.input] ||= {}
    DATA_KEYS.each_pair do |key, plural_key|
      results[cars_matcher.input][plural_key] ||= Set.new
      results[cars_matcher.input][plural_key] << cars_matcher.target[key]
    end
  end

  def car_matcher
    @car_matcher ||= CarMatcher.new(@car_input)
  end

  def search_params
    @search_params ||= car_wrapper.car_for_search
  end

  def car_wrapper
    @car_wrapper ||= CarWrapper.new(@car_input)
  end

  def find_entry(input, collection)
    return if input.blank? || collection.blank?

    uniq_collection = collection.uniq
    return uniq_collection.first if uniq_collection.size == 1

    uniq_collection.find { |e| e.downcase == input.downcase }
  end
end
