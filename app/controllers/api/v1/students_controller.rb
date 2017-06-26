module Api
  module V1
    class StudentsController < ApiController
      def show
        student = Student.where(user_id: params[:user_id]).first!
        render json: { success: true, students: student.as_json }
      end
    end
  end
end
