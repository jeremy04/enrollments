class CourseListController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json { render json: EnrollmentsDatatable.new(view_context) } 
    end
  end
end

class EnrollmentsDatatable
  delegate :params, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      recordsTotal: count,
      data: data,
      recordsFiltered: total_entries
    }
  end

  private

  def data
    enrollments.pluck(:course_name, :user_name)
  end

  def enrollments
    @enrollments ||= fetch_enrollments
  end

  def fetch_enrollments
    enrollments = Enrollment.active_course_list.order("#{sort_column} #{sort_direction}")
    enrollments.page(page).per(per_page)
  end

  def total_entries
    enrollments.total_count
  end

  def count
    enrollments.count(:all)
  end

  def page
    params[:start].to_i / per_page + 1
  end

  def per_page
    10
  end

  def sort_column
    columns[params[:order]['0'][:column].to_i]
  end

  def sort_direction
    params[:order]['0'][:dir] == "desc" ? "desc" : "asc"
  end

  def columns
    %w(course_name user_name)
  end

end
