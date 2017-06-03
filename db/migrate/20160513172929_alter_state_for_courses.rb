class AlterStateForCourses < ActiveRecord::Migration
  def change
    change_column :courses, :state, 'integer USING CAST(state AS integer)'
  end
end
