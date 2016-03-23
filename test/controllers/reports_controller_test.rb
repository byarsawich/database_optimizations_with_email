require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  test "should get all_data" do
    get :all_data, {name: "a1"}
    assert_response :success
  end

  test "should upload file from user" do
    test_csv = Rails.root.join("test/fixtures/test.csv")
    file = Rack::Test::UploadedFile.new(test_csv, "text/csv")
    post :upload_thank_you, filename: file
    assert_response :success
    assert File.file?(Rails.root.join("public/uploads/test.csv"))
    File.delete(Rails.root.join("public/uploads/test.csv"))
  end
end
