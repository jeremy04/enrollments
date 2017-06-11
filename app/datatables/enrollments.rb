module Datatables
  class Enrollments
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
      enrollments.nil? ? [] : enrollments.pluck(:course_name, :user_name)
    end

    def enrollments
      @enrollments ||= fetch_enrollments
    end

    def fetch_enrollments
      unless  params[:search][:value].blank?

        enrollments = Enrollment.active_course_list.order("#{sort_columns}")
        enrollments = enrollments.page(page).per(per_page)

        fields = [ Course.arel_table[:course_name], Student.arel_table[:user_name] ]
        node = fields.shift
        search_value = params[:search][:value]

        relation = fields.inject(node.matches("%#{search_value}%")) do |acc, node| 
          acc.or(node.matches("%#{params[:search][:value]}%"))
        end
        enrollments = enrollments.where(relation)
      end
    end

    def total_entries
      enrollments.nil? ? 10 : enrollments.total_count
    end

    def count
      enrollments.nil? ? 0 : enrollments.count(:all)
    end

    def page
      params[:start].to_i / per_page + 1
    end

    def per_page
      10
    end

    def sort_columns
      params[:order].map { |k,v| "#{columns[v['column'].to_i]} #{v['dir']}"  }.join(",")
    end

    def columns
      %w(course_name user_name)
    end

  end
end
