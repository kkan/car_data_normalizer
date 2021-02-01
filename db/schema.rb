# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table :makes do |table|
    table.column :title, :string
  end

  create_table :models do |table|
    table.column :title, :string
    table.column :make_id, :integer
  end

  create_table :trims do |table|
    table.column :title, :string
    table.column :model_id, :integer
  end
end
