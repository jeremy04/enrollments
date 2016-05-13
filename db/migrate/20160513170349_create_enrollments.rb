class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.string :user_id
      t.string :course_id
      t.string :state
    end
  end
end
