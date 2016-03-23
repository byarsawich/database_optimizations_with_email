require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  include ActiveJob::TestHelper

  test "should get all_data" do
    get :all_data, {name: "a1"}
    assert_response :success
  end

  test "should upload file from user" do
    test_csv = Rails.root.join("test/fixtures/test.csv")
    file = Rack::Test::UploadedFile.new(test_csv, "text/csv")
    post :upload_thank_you, filename: file
    assert_response :success
    assert File.file?(Rails.root.join("tmp/test.csv"))
    File.delete(Rails.root.join("tmp/test.csv"))
  end

  test "create job for all_data" do
    assert_enqueued_with(job: MailReportJob, args: ["test@test.com", "a1"], queue: "mail_report") do
      post :all_data_job, {address: "test@test.com", name: "a1"}
    end
    assert_redirected_to thank_you_path

  end

  # test "create job for search" do
  #   assert_enqueued_with(job: MailSearchJob, args: ["test@test.com", "a4"], queue: "mail_search") do
  #     post :search_job, {address: "test@test.com", search: "a4"}
  #   end
  #   assert_redirected_to thank_you_path
  # end
end
