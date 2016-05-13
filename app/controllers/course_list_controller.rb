class CourseListController < ApplicationController
  def index
    @courses = Course.active
  end
end
