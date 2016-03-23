require 'test_helper'

class UserUploadTest < ActionDispatch::IntegrationTest
  test "user uploads a file" do
    get upload_path
    assert_response :success

    assert_template "upload"
    assert_select "input[type=file]", 1

    #upload file
    test_csv = Rails.root.join("test/fixtures/test.csv")
    file = Rack::Test::UploadedFile.new(test_csv, "text/csv")
    post_via_redirect(upload_path, filename: file)

    assert_template "upload_thank_you"
    assert_equal "/upload", path
  end

  # test "login authenticates" do
    # get root_path
    # assert_redirected_to login_path
    # follow_redirect!
    # assert_template "new"
    # assert_select "#notice", 1
    # assert_select "input[type=email]", 1
    # assert_select "input[type=password]", 1
    #
    # #log in
    # post login_path email: "aa@aa.com", password: "monkey"
    # assert_redirected_to teacher_index_path
    # follow_redirect!
    #
    # #make sure that I can see teachers
    # assert_select "tbody tr", Teacher.count
    #
    # #create a teacher
    #
    # #make sure I can see one more
  # end
end
