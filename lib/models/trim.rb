# frozen_string_literal: true

class Trim < ActiveRecord::Base
  belongs_to :model

  def self.by_make_and_model(make_query:, model_query:)
    relation = includes(model: :make).references(model: :make)
    relation = relation.where('lower(makes.title) LIKE ?', "#{make_query.downcase}%") if make_query.present?
    relation = relation.where('lower(models.title) LIKE ?', "#{model_query.downcase}%") if model_query.present?

    relation
  end

  def car_hash
    @car_hash ||= {
      make: make_title,
      model: model_title,
      trim: title
    }
  end

  def make_title
    @make_title ||= model.make.title
  end

  def model_title
    @model_title ||= model.title
  end
end
