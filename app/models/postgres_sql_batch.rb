class PostgresSqlBatch

  def initialize(table, update: false, index: nil, no_update: [])
    @table = table
    @update = update
    @index = index
    @no_update = no_update
  end

  def create_or_update(data)
    data = data.compact.map { |d| d.with_indifferent_access }
    data = dedupe_batch(data, @index) if @update
    return false if data.empty?
    columns = data.first.keys
    query = sql_format(columns, data)
    bindings = make_bindings(columns, data)
    execute_insert(query, bindings)
  end

  private

  def make_bindings(columns, data)
    data.map { |row| row.values_at(*columns) }.flatten
  end

  def dedupe_batch(data, id)
    data.reverse.uniq { |d| d[id] }.reverse
  end

  def sql_format(columns, data)
    <<-SQL
INSERT INTO #{@table}
  (#{column_clause(columns)})
VALUES
    #{insert_clause(data)}
#{duplicate_update_clause(columns)}
    SQL
  end

  def column_clause(names)
    names.map { |n| "#{n}" }.join(', ')
  end

  def insert_clause(data)
    data.map { |row| "(#{row_placeholder(row)})" }.join(", ")
  end

  def row_placeholder(row)
    Array.new(row.keys.size, '?').join(",")
  end

  def duplicate_update_clause(columns)
    if @update
      <<-SQL
ON CONFLICT(#{@index})
DO UPDATE SET
  #{update_clause(columns)}
      SQL
    else
      ''
    end
  end

  def update_clause(columns)
    (columns - @no_update).map { |c| "#{c}=EXCLUDED.#{c}" }.join(", ")
  end

  def execute_insert(sql, bindings)
    safe_sql = sanitize_sql(sql, bindings)
    ActiveRecord::Base.connection.execute(safe_sql)
  end

  def sanitize_sql(sql, bindings)
    ActiveRecord::Base.send(:sanitize_sql_array, [sql, *bindings])
  end

end
