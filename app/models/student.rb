class Student < ActiveRecord::Base
  enum state: [ :active, :deleted ]
end
