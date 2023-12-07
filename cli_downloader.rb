# frozen_string_literal: true

require 'csv'
require 'open-uri'
require 'fileutils'
require 'readline'
require 'pathname'

def download_images_from_csv(csv_file, destination_folder)
  FileUtils.mkdir_p(destination_folder) unless Dir.exist?(destination_folder)

  CSV.foreach(csv_file, headers: true) do |row|
    product = row['product']
    image_url = row['url']
    image_extension = File.extname(image_url)
    image_name = product.downcase.gsub(/\s+/, '_')
    unique_name = generate_unique_name(destination_folder, image_name, image_extension)
    image_path = File.join(destination_folder, unique_name)

    begin
      open(image_path, 'wb') do |file|
        file << URI.open(image_url).read
      end
      puts "Downloaded #{product} to #{image_path}"
    rescue StandardError => e
      puts "Failed to download #{product} from #{image_url}: #{e.message}"
    end

    sleep(1) # Add a 1-second delay between downloads
  end
end

def generate_unique_name(destination_folder, name, extension)
  count = 0
  unique_name = "#{name}#{extension}"

  while File.exist?(File.join(destination_folder, unique_name))
    count += 1
    unique_name = "#{name}_#{count}#{extension}"
  end

  unique_name
end

# Enable tab autocompletion for destination folder
destination_folder = Readline.readline('Enter the destination folder path: ', true)
destination_folder.gsub!(/^~/, Dir.home) if destination_folder.start_with?('~')

# Usage
puts 'Enter the CSV file path:'
csv_file = gets.chomp

download_images_from_csv(csv_file, destination_folder)
puts 'Images downloaded successfully!'
