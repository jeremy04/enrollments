require "rails_helper"

describe "RecordImporter" do

  describe "call" do

    describe "imports students" do
      it "successfully adds students" do
        txt = 
          "user_id,user_name,state\nU531649,Noah Thomas,active\nU346561,Chloe Wood,active"
        io = StringIO.new(txt)
        importer = RecordImporter.new(io)
        importer.call
        expect(Student.count).to eql 2
      end

      it "updates duplicate user_ids" do
        Student.create!(user_id: "U531649", state: "active", user_name: "Jeremy Lipson")
        txt = 
          "user_id,user_name,state\nU531649,Noah Thomas,deleted"
        io = StringIO.new(txt)
        importer = RecordImporter.new(io)
        importer.call
        expect(Student.count).to eql 1
        expect(Student.first.user_name).to eql "Noah Thomas"
        expect(Student.first.state).to eql "deleted"
      end
    end

    describe "imports courses" do
      it "successfully adds courses" do
        txt = 
          "course_id,course_name,state\nC628944,Suicide,active\nC424294,Chemistry,active"
        io = StringIO.new(txt)
        importer = RecordImporter.new(io)
        importer.call
        expect(Course.count).to eql 2
      end

      it "updates duplicate user_ids" do
        Course.create!(course_id: "C628944", course_name: "Math", state: "active")
        txt = 
          "course_id,course_name,state\nC628944,Chemistry,active\n"
        io = StringIO.new(txt)
        importer = RecordImporter.new(io)
        importer.call
        expect(Course.count).to eql 1
        expect(Course.first.course_name).to eql "Chemistry"
      end
    end

    describe "imports enrollments" do
      it "imports enrollments" do
        Student.create!(user_id: "U100")
        Student.create!(user_id: "U101")
        Course.create!(course_id: "C100")
        Course.create!(course_id: "C101")

        txt = 
          "course_id,user_id,state\nC100,U100,deleted\nC100,U101,active"
        io = StringIO.new(txt)
        importer = RecordImporter.new(io)
        importer.call
        expect(Course.count).to eql 2
      end

      it "integrates valid course_id, skips invalid enrollments w/ missing course_id " do
        Student.create!(user_id: "U100")
        Student.create!(user_id: "U101")
        Course.create!(course_id: "C101")

        txt = 
          "course_id,user_id,state\nC100,U100,deleted\nC101,U101,deleted\n"
        io = StringIO.new(txt)
        importer = RecordImporter.new(io)
        importer.call
        expect(Course.count).to eql 1
      end
    end

    describe "does not process CSV without the right headers" do
      it "should raise an exception if CSV header not supported" do
        txt = "invalid_header\nMercy,Mercy,Mercy\n"
        io = StringIO.new(txt)
        importer = RecordImporter.new(io)
        expect{ importer.call }.to raise_error(RuntimeError, "Invalid csv file")
      end
    end

  end
end
