Enrollments Importing

Schools use many different Student Information Systems, some commercial, some homegrown, some are even just an excel spreadsheet. We give various options for synchronizing this data, one option is the school can send us CSV files each time things change, and we'll process the CSV to make the appropriate changes into Enrollments.

In this problem we're only going to consider three data types: Students, Courses, and Enrollments. Enrollments is a join between Students and Courses.

student columns: user_id, user_name, state
course columns: course_id, course_name, state
enrollment columns: user_id, course_id, state

For all data types, state is in ['active', 'deleted']. The user_id and course_id are globally unique, so a new id means a new record, an id they've seen before means an update to an existing record.

Attached is a .zip of CSVs. You should write a program that processes the files in order. You'll need to determine the type of data in the csv based on the headers in the first row. At the end, you need to spit out a list of active courses, and for each course a list of active students with active enrollments in that course.

Some gotchas:

Some of the enrollments are invalid (reference non-existing user or course).
Watch out for quoting problems if you try to parse the CSVs by hand
An active enrollment might point to a deleted user, and enrollments may be deleted as well.
Column order in the CSV is unspecified, one user csv may be ordered differently than the next.


Installing:

    rbenv install (if Ruby 2.4.1 is not already installed) 
    rbenv rehash

    gem install bundler
    
    bundle install

    rake db:schema:load
    
    rake csv_importer:import_all
    
    rspec spec
    
    rails s

Shortcomings:

- SQLite3 has no enums, or foreign key constraints that work with Rail's adapters
- My motto is make it work before you make it pretty. Maybe add a Search UI ?


