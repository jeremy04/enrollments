class Enrollment < ActiveRecord::Base
  enum state: [ :active, :deleted ]
  belongs_to :student, foreign_key: "user_id", primary_key: "user_id"
  belongs_to :course, foreign_key: "course_id"
end
