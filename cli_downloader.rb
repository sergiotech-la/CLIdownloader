# frozen_string_literal: true

require 'csv'
require 'open-uri'

def download_images_from_csv(csv_file, destination_folder)
  Dir.mkdir(destination_folder) unless Dir.exist?(destination_folder)
  CSV.foreach(csv_file, headers: true) do |row|
    product = row['product']
    image_url = row['url']
    image_name = product.downcase.gsub(/\s+/, '_')
    image_path = File.join(destination_folder, generate_unique_name(image_name))
    open(image_path, 'wb') do |file|
      file << open(image_url).read
    end
    puts "Downloaded #{product} to #{image_path}"
    sleep(1) # Add a 1 second delay between downloads
  end
end

def generate_unique_name(name)
  count = 0
  unique_name = name
  while File.exist?(File.join('images', unique_name))
    unique_name = "#{name}_#{count}"
    count += 1
  end
  unique_name
end

puts 'Enter the CSV file path:'
csv_file = gets.chomp

puts 'Enter the destination folder path:'
destination_folder = gets.chomp

download_images_from_csv(csv_file, destination_folder)
puts 'Images downloaded successfully!'
