require 'csv'

class RecordImporter
  CSV_ARGS = {
    :headers => :true,
    :skip_blanks => true,
    :header_converters => :downcase,
    :converters => lambda{|field|field ? field.strip : field}
  }


  def initialize(file) 
    @file = file
  end

  def call
    CSV.foreach(@file, CSV_ARGS.merge(headers: false)) do |row|
      if row.include?("user_id") && row.include?("user_name")
        create_students(@file)
      elsif row.include?("course_id") && row.include?("course_name")
        create_courses(@file)
      elsif row.include?("course_id") && row.include?("user_id")
        create_enrollments(@file)
      else
        raise "Invalid csv file"
      end
      break
    end
  end

  private

  def create_students(file)
    CSV.foreach(file, CSV_ARGS.merge({ headers: true} )) do |row|
      student = Student.find_or_create_by(user_id: row['user_id'])
      student.update(row.to_hash)
    end
  end

  def create_courses(file)
    CSV.foreach(file, CSV_ARGS.merge({ headers: true} )) do |row|
      course = Course.find_or_create_by(course_id: row['course_id'])
      course.update(row.to_hash)
    end
  end

  def create_enrollments(file)
    CSV.foreach(file, CSV_ARGS.merge({ headers: true } )) do |row|
      # skip invalid enrollments w/ no course/ student
      course_id = row['course_id']
      user_id   = row['user_id']
      state     = row['state']

      # this would be nicer with real foreign key support like Postgres or MySQL
      next if Course.where(course_id: course_id).pluck(:course_id).nil?
      next if Student.where(user_id: user_id).pluck(:user_id).nil?

      enrollment = Enrollment.find_or_create_by(course_id: course_id, user_id: user_id)
      enrollment.state = state
      enrollment.save!
    end
  end

end  
