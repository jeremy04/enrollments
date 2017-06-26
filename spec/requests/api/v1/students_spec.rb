require "rails_helper"

RSpec.describe "Students API", :type => :request do
  let(:headers) do
    {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
  end

  it "returns a single student" do
    Student.create!(user_id: 2, user_name: "U9000", state: :active) 
    get '/api/v1/students/2', '', headers
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(json['students']['user_name']).to eql "U9000" 
  end
end
