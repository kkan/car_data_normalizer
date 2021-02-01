# frozen_string_literal: true

class Model < ActiveRecord::Base
  has_many :trims
  belongs_to :make
end
