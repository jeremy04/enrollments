class Student < ActiveRecord::Base
  enum state: [ :active, :deleted ]
  has_many :enrollments, foreign_key: "user_id", primary_key: "user_id"
  has_many :courses, through: :enrollments

  scope :active, -> { where(state: "active") }

end
