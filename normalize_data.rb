#!ruby

# ruby version 2.7

require 'yaml'
require 'active_record'
Dir['./lib/**/*.rb'].sort.each { |file| require file }

db_config = YAML.load_file('config/database.yml')
ActiveRecord::Base.establish_connection(db_config)

def normalize_data(input)
  {
    year: YearNormalizer.new(input[:year]).process,
    **CarDataNormalizer.new(input.slice(:make, :model, :trim)).process
  }
end

# example with Chevrolet Impala does not pass, cause there is no 'st' trim ('ss' works fine)
examples = [
  [{ year: '2018', make: 'fo', model: 'focus', trim: 'blank' },
   { year: 2018, make: 'Ford', model: 'Focus', trim: nil }],
  [{ year: '200', make: 'blah', model: 'foo', trim: 'bar' },
   { year: '200', make: 'blah', model: 'foo', trim: 'bar' }],
  [{ year: '1999', make: 'Chev', model: 'IMPALA', trim: 'st' },
   { year: 1999, make: 'Chevrolet', model: 'Impala', trim: 'ST' }],
  [{ year: '2000', make: 'ford', model: 'focus se', trim: '' },
   { year: 2000, make: 'Ford', model: 'Focus', trim: 'SE' }]
]

additional_examples = [
  [{ year: '1999', make: 'Chev', model: 'IMPALA', trim: 'ss' },
   { year: 1999, make: 'Chevrolet', model: 'Impala', trim: 'SS' }],
  [{ year: '2000', make: 'ford', model: 'focus s', trim: '' },
   { year: 2000, make: 'Ford', model: 'Focus', trim: 'S' }],
  [{ year: '2000', make: 'ford', model: 'focu se', trim: '' },
   { year: 2000, make: 'Ford', model: 'Focus', trim: 'SE' }],
  [{ year: '1998', make: 'suba', model: 'lega', trim: ' ' },
   { year: 1998, make: 'Subaru', model: 'Legacy', trim: ' ' }],
  [{ year: '1998', make: 'suba', model: 'lega out', trim: ' ' },
   { year: 1998, make: 'Subaru', model: 'Legacy', trim: 'out' }],
  [{ year: '1998', make: 'suba', model: 'lega outback', trim: ' ' },
   { year: 1998, make: 'Subaru', model: 'Legacy', trim: 'Outback' }],
  [{ year: '202', make: 'ki', model: 'ri bas', trim: '' },
   { year: '202', make: 'Kia', model: 'Rio', trim: 'Base' }],
  [{ year: '202', make: 'ki', model: 'ri', trim: '' },
   { year: '202', make: 'Kia', model: 'ri', trim: '' }],
  [{ year: '202', make: 'ki', model: 'rio', trim: '' },
   { year: '202', make: 'Kia', model: 'Rio', trim: '' }],
  [{ year: '202', make: 'ki', model: 'ri ba', trim: '' },
   { year: '202', make: 'Kia', model: 'Rio', trim: 'Base' }],
  [{ year: '1984', make: 'Dod', model: 'ram 50', trim: 'rot' },
   { year: 1984, make: 'Dodge', model: 'Ram 50', trim: 'rot' }],
  [{ year: '1989', make: 'For', model: 'E-150', trim: 'Econoline Club Wa Cust' },
   { year: 1989, make: 'Ford', model: 'E-150 Econoline Club Wagon', trim: 'Custom' }],
  [{ year: '1978', make: 'Chev', model: 'Camar l', trim: '' },
   { year: 1978, make: 'Chevrolet', model: 'Camaro', trim: 'l' }],
  [{ year: '1978', make: 'f', model: 'f', trim: '' },
   { year: 1978, make: 'f', model: 'f', trim: '' }],
  [{ year: '1978', make: 'f', model: 'f', trim: 'lu' },
   { year: 1978, make: 'FAW', model: 'f', trim: 'lu' }],
  [{ year: '1978', make: 'faw', model: 'f', trim: 'blank' },
   { year: 1978, make: 'FAW', model: 'f', trim: nil }],
  [{ year: '1978', make: 'jagua', model: 'xjs las', trim: ' ' },
   { year: 1978, make: 'Jaguar', model: 'xjs las', trim: ' ' }],
  [{ year: '1978', make: 'Chevrole', model: 'C1', trim: 'blank' },
   { year: 1978, make: 'Chevrolet', model: 'C1', trim: nil }],
  [{ year: '1978', make: 'Chevrol', model: 'blank', trim: 'blank' },
   { year: 1978, make: 'Chevrolet', model: nil, trim: nil }],
  [{ year: '1978', make: 'blank', model: 'Camar', trim: 'blank' },
   { year: 1978, make: nil, model: 'Camar', trim: nil }],
  [{ year: '1978', make: 'p', model: 'ph', trim: 's' },
   { year: 1978, make: 'Pontiac', model: 'Phoenix', trim: 's' }],
  [{ year: '1978', make: 'scani', model: 'blank', trim: 'blank' },
   { year: 1978, make: 'Scania', model: nil, trim: nil }],
  [{ year: '1978', make: 'foto', model: 'aumark 700 cummins', trim: '700' },
   { year: 1978, make: 'Foton', model: 'Aumark 7000', trim: 'Cummins 7000' }]
]

(examples + additional_examples).each_with_index do |(input, expected_output), index|
  if (output = normalize_data(input)) == expected_output
    puts "Example #{index + 1} passed!"
  else
    puts "Example #{index + 1} failed,
          Expected: #{expected_output.inspect}
          Got:      #{output.inspect}"
  end
end
