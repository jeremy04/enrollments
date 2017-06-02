module Batchable
  def self.line_count(file)
    `wc -l #{file}`.to_i - 1
  end

  def read_in_batches(file, batch_size: 100)
    records = []
    line_count = Batchable.line_count(file)

    CSV.foreach(file, RecordImporter::CSV_ARGS.merge({ headers: true} )) do |row|
      records << row
      if records.size == batch_size || records.size == line_count
        yield records
        records = []
      end
    end
  end

end
