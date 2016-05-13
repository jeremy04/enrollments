require "rails_helper"

feature "Viewing courses" do
  scenario "Display all active courses" do
    Student.create!(user_id: "U531649", state: "active", user_name: "Jeremy Lipson")
    Course.create!(course_id: "C628944", course_name: "Math", state: "active")
    Enrollment.create!(course_id: "C628944", user_id: "U531649", state: "active")        
    visit "/"
    expect(page).to have_content('Math')
    expect(page).to have_content('Jeremy Lipson')
  end
end
