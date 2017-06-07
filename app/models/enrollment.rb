class Enrollment < ActiveRecord::Base
  enum state: [ :active, :deleted ]
  belongs_to :student, foreign_key: "user_id", primary_key: "user_id"
  belongs_to :course, foreign_key: "course_id", primary_key: "course_id"

  scope :active, -> { where(state: "active") }

  def self.active_course_list
    self
      .joins(:course).where(courses: { state: 'active' })
      .joins('LEFT JOIN "students" ON "students".user_id = "enrollments".user_id AND "students"."state" = 0')
      .active
  end

end
