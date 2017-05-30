namespace :csv_importer do
  desc "CSV importer"
  task :import_all => :environment do
    folder = ENV["CSV_FOLDER_LOCATION"] || "#{Rails.root}/lib/csvs"
    Dir.glob(File.join(folder,"*.csv")).each do |file_name|
      importer = RecordImporter.new(file_name)
      importer.call
    end
  end
end

