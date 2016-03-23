require 'test_helper'

class UserUploadTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

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

  test "user makes serach and job creats a csv" do
    get search_path
    assert_response :success

    assert_template "search"

    #submit search
    assert_enqueued_with(job: MailSearchJob, args: ["test@test.com", "MyString"], queue: "mail_search") do
      post search_path, {address: "test@test.com", search: "MyString"}
      assert_redirected_to thank_you_path
    end


    numcsv = Dir.glob("#{Rails.root}/tmp/*.csv").length
    assert_no_performed_jobs
    perform_enqueued_jobs do
      post search_path, {address: "test@test.com", search: "MyString"}
    end
    assert_performed_jobs 1
    assert_equal numcsv + 1, Dir.glob("#{Rails.root}/tmp/*.csv").length

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
