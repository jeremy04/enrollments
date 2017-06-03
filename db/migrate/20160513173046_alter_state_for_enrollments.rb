class AlterStateForEnrollments < ActiveRecord::Migration
  def change
    change_column :enrollments, :state, 'integer USING CAST(state AS integer)'
  end
end
