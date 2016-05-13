class AlterStateForCourses < ActiveRecord::Migration
  def change
    change_table :courses do |t|
      t.change :state, :integer
    end
  end
end
