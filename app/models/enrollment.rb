class Enrollment < ActiveRecord::Base
  enum state: [ :active, :deleted ]
end
