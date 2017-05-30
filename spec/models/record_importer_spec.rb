require "rails_helper"
require "csv"

describe "RecordImporter" do

  describe "call" do

    describe "imports students" do
      it "successfully adds students" do
        csv = [
          ["user_id", "user_name", "state"],
          { user_id: "U531649", user_name: "Noah Thomas", state: "active"}, 
          { user_id: "U346561", user_name: "Chloe Wood", state: "active"} 
        ]


        expect(CSV).to receive(:foreach).with("csv_file", RecordImporter::CSV_ARGS.merge(headers: false)).and_yield(csv[0])
        expect(CSV).to receive(:foreach).with("csv_file", RecordImporter::CSV_ARGS.merge(headers: true)).and_yield(csv[1]).and_yield(csv[2])

        importer = RecordImporter.new("csv_file")
        importer.call

        expect(Student.count).to eql 2
      end

      it "updates duplicate user_ids" do
        Student.create!(user_id: "U531649", state: "active", user_name: "Jeremy Lipson")
        csv = [
          ["user_id", "user_name", "state"],
          { user_id: "U531649", user_name: "Noah Thomas", state: "deleted"}.with_indifferent_access, 
        ]


        expect(CSV).to receive(:foreach).with("csv_file", RecordImporter::CSV_ARGS.merge(headers: false)).and_yield(csv[0])
        expect(CSV).to receive(:foreach).with("csv_file", RecordImporter::CSV_ARGS.merge(headers: true)).and_yield(csv[1])

        importer = RecordImporter.new("csv_file")
        importer.call
        expect(Student.count).to eql 1
        expect(Student.first.user_name).to eql "Noah Thomas"
        expect(Student.first.state).to eql "deleted"
      end
    end

    describe "imports courses" do
      it "successfully adds courses" do
        csv = [
          ["course_id", "course_name", "state"],
          { course_id: "C628944", course_name: "Algebra", state: "active"}.with_indifferent_access,
          { course_id: "C424294", course_name: "Chemistry", state: "active"}.with_indifferent_access
        ]

        expect(CSV).to receive(:foreach).with("csv_file", RecordImporter::CSV_ARGS.merge(headers: false)).and_yield(csv[0])
        expect(CSV).to receive(:foreach).with("csv_file", RecordImporter::CSV_ARGS.merge(headers: true)).and_yield(csv[1]).and_yield(csv[2])

        importer = RecordImporter.new("csv_file")
        importer.call
        expect(Course.count).to eql 2
      end

      it "updates duplicate user_ids" do
        Course.create!(course_id: "C628944", course_name: "Math", state: "active")
        csv = [
          ["course_id", "course_name", "state"],
          { course_id: "C628944", course_name: "Chemistry", state: "active"}.with_indifferent_access,
        ]

        expect(CSV).to receive(:foreach).with("csv_file", RecordImporter::CSV_ARGS.merge(headers: false)).and_yield(csv[0])
        expect(CSV).to receive(:foreach).with("csv_file", RecordImporter::CSV_ARGS.merge(headers: true)).and_yield(csv[1])

        importer = RecordImporter.new("csv_file")
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
        csv = [
          ["course_id", "user_id", "state"],
          { course_id: "C100", user_id: "U101", state: "active"}.with_indifferent_access,
        ]

        expect(CSV).to receive(:foreach).with("csv_file", RecordImporter::CSV_ARGS.merge(headers: false)).and_yield(csv[0])
        expect(CSV).to receive(:foreach).with("csv_file", RecordImporter::CSV_ARGS.merge(headers: true)).and_yield(csv[1])

        importer = RecordImporter.new("csv_file")
        importer.call
        expect(Course.count).to eql 2
      end

      it "integrates valid course_id, skips invalid enrollments w/ missing course_id " do
        Student.create!(user_id: "U100")
        Student.create!(user_id: "U101")
        Course.create!(course_id: "C101")
        csv = [
          ["course_id", "user_id", "state"],
          { course_id: "C100", user_id: "U100", state: "deleted"}.with_indifferent_access,
          { course_id: "C100", user_id: "U101", state: "deleted"}.with_indifferent_access,
        ]

        expect(CSV).to receive(:foreach).with("csv_file", RecordImporter::CSV_ARGS.merge(headers: false)).and_yield(csv[0])
        expect(CSV).to receive(:foreach).with("csv_file", RecordImporter::CSV_ARGS.merge(headers: true)).and_yield(csv[1]).and_yield(csv[2])

        importer = RecordImporter.new("csv_file")
        importer.call
        expect(Course.count).to eql 1
      end
    end

    describe "does not process CSV without the right headers" do
      it "should raise an exception if CSV header not supported" do
        csv = [
          [:mercy, :mercy, :mercy],
        ]
        expect(CSV).to receive(:foreach).with("csv_file", RecordImporter::CSV_ARGS.merge(headers: false)).and_yield(csv[0])

        importer = RecordImporter.new("csv_file")
        expect{ importer.call }.to raise_error(RuntimeError, "Invalid csv file")
      end
    end

  end
end
