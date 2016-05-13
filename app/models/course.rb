class Course < ActiveRecord::Base
  enum state: [ :active, :deleted ]
end
