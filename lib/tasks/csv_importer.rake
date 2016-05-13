
namespace :csv_importer do
  desc "CSV importer"
  task :import_all => :environment do
    folder = ENV["CSV_FOLDER_LOCATION"] || "#{Rails.root}/lib/csvs"
    Dir.glob(File.join(folder,"*.csv")).each do |file_name|
      file = File.open(file_name, "r")
      importer = RecordImporter.new(file)
      importer.call
    end
  end
end

