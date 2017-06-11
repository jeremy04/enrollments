class EnrollmentsController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json { render json: Datatables::Enrollments.new(view_context) } 
    end
  end
end
