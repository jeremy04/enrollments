class AlterStateForStudents < ActiveRecord::Migration
  def change
    change_table :students do |t|
      t.change :state, :integer
    end
  end
end
