class AlterStateForEnrollments < ActiveRecord::Migration
  def change
    change_table :enrollments do |t|
      t.change :state, :integer
    end
  end
end
