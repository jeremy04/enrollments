require 'csv'

class RecordImporter

  def initialize(file) 
    @file = file
  end

  def call
    # Reads entire file into memory, might not be suitable for large csvs

    @csv = CSV.parse(@file.read, :row_sep => "\n", headers: true)
    if @csv.headers == ["user_id", "user_name", "state"]
      create_students
    elsif @csv.headers == ["course_id", "course_name", "state"]
      create_courses
    elsif @csv.headers == ["course_id", "user_id" , "state"]
      create_enrollments
    else
      raise "Invalid csv file"
    end
    @file.close
  end

  private

  def create_students
    @csv.each do |row|
      student = Student.find_or_create_by(user_id: row[0])
      student.user_name = row[1]
      student.state = row[2]
      student.save!
    end
  end

  def create_courses
    @csv.each do |row|
      course = Course.find_or_create_by(course_id: row[0])
      course.course_name = row[1]
      course.state = row[2]
      course.save!
    end
  end

  def create_enrollments
    @csv.each do |row|
      # skip invalid enrollments w/ no course/ student
      course_id = row[0]
      user_id   = row[1]
      state     = row[2]

      # this would be nicer with real foreign key support like Postgres or MySQL
      next if Course.where(course_id: course_id).pluck(:course_id).nil?
      next if Student.where(user_id: user_id).pluck(:user_id).nil?

      enrollment = Enrollment.find_or_create_by(course_id: course_id, user_id: user_id)
      enrollment.state = state
      enrollment.save!
    end
  end

end  
