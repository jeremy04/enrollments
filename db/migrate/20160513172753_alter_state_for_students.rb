class AlterStateForStudents < ActiveRecord::Migration
  def change
    change_column :students, :state, 'integer USING CAST(state AS integer)'
  end
end
