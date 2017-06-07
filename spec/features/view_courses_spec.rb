require "rails_helper"

feature "Viewing courses" do
  scenario "Display all active courses", js: true do
    Student.create!(user_id: "U531649", state: "active", user_name: "Jeremy Lipson")
    Student.create!(user_id: "U500000", state: "active", user_name: "Frank Bauer")
    Course.create!(course_id: "C628944", course_name: "Math", state: "active")
    Enrollment.create!(course_id: "C628944", user_id: "U500000", state: "deleted")
    Enrollment.create!(course_id: "C628944", user_id: "U531649", state: "active")        
    visit "/"
    expect(page).to have_content('Math')
    expect(page).to have_content('Jeremy Lipson')
    expect(page).to have_no_content('Frank Bauer')
  end
end
