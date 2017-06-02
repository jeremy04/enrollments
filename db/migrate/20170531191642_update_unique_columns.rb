class UpdateUniqueColumns < ActiveRecord::Migration
  def change
    change_table :students do |t|
      t.index [:user_id], unique: true, name: 'unique_index_user_id_students'
    end
    
    change_table :courses do |t|
      t.index [:course_id], unique: true, name: 'unique_index_course_id_courses'
    end

    change_table :enrollments do |t|
      t.index [:course_id, :user_id], unique: true, name: 'unique_index_course_id_user_id_enrollments'
    end
  end
end
