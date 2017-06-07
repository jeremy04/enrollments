class Course < ActiveRecord::Base
  enum state: [ :active, :deleted ]
  has_many :enrollments, foreign_key: "course_id", primary_key: "course_id"
  has_many :students, through: :enrollments
  
  scope :active, -> { where(state: "active") }
end
