require 'csv'

class RecordImporter
  include Batchable

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
        StudentImporter.new(@file).create_or_update
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

  # Performance issue: find_or_create_by will do two queries for every record, Sqllite has no support for mult-insert insert + update like ON DUPLICATE KEY

  class StudentImporter
    include Batchable
    
    def initialize(file)
      @file = file
    end

    def create_or_update
      read_in_batches(@file) do |rows|
        rows.each do |row|
          student = Student.find_or_create_by(user_id: row['user_id'])
          student.update(row.to_hash)
        end
      end
    end
  end

  #TODO: refactor the rest

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
