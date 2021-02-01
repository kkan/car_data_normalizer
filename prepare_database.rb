# frozen_string_literal: true

require 'csv'
require 'yaml'
require 'active_record'
Dir['./lib/models/*.rb'].sort.each { |file| require file }

db_config = YAML.load_file('config/database.yml')
ActiveRecord::Base.establish_connection(db_config)
load('db/schema.rb') unless File.exist?(db_config['database'])

data_path = 'data/MVL010321.csv'

CSV.foreach(data_path, headers: true).with_index do |row, i|
  make = Make.find_or_create_by(title: row['Make'])
  model = make.models.find_or_create_by(title: row['Model'])
  model.trims.find_or_create_by(title: row['Submodel'])

  puts "#{i} rows processed" if (i % 10_000).zero?
end
