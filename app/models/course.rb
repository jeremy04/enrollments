class Course < ActiveRecord::Base
  enum state: [ :active, :deleted ]
  has_many :enrollments, foreign_key: "course_id", primary_key: "course_id"
  has_many :students, through: :enrollments

  scope :active, -> { includes(:students).where(students: { state: 'active'}, enrollments: { state: 'active' } ).where(state: 'active') }
end
