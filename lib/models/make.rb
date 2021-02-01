# frozen_string_literal: true

class Make < ActiveRecord::Base
  has_many :models

  def self.matched_titles(query)
    return [] if query.blank?

    where('lower(title) LIKE ?', "#{query.downcase}%").pluck(:title)
  end
end
