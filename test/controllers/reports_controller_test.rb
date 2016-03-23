require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  test "should get all_data" do
    get :all_data, {name: "a1"}
    assert_response :success
  end

  test "should upload file from user" do
    test_csv = Rails.root.join("test/fixtures/test.csv")
    file = Rack::Test::UploadedFile.new(test_csv, "text/csv")
    post :thank_you, filename: file
    assert_response :success
    assert File.file?(Rails.root.join("public/uploads/test.csv"))
    File.delete(Rails.root.join("public/uploads/test.csv"))
  end

  test "should upload csv from user and put into databse" do
    test_csv = Rails.root.join("test/fixtures/test.csv")
    file = Rack::Test::UploadedFile.new(test_csv, "text/csv")
    post :thank_you, filename: file
    File.delete(Rails.root.join("public/uploads/test.csv"))
    assert_equal 5, Assembly.all.count
    assert_equal "CACTTCTAGGATTATTTCACACGTGGCATGATTGGCGCGTCAGCACCTCCACGGCCCCCAAACTATATGAACACCTAAGTTACACAGGTTTTATACACAACATGTAAAGGGGATTGATCACCGACTTAGCGACGGAGTGATGAGTATCTAAGGTCGGGTTCTAGAGTCCTATCCAGGGAAGTGATGGAAGTTGGCTATTCATTCGGGGTGGTTGTAGCCGCAACCAGGCCTCCCATCTTAGGAATTGGCGAAACATTACCTATTGGCTATTAGAGACCTACCTAATCTGAGATTGGCCGCTACGGTTATTACTTGTCACCATGGGTGCCGCGCGCAAGTCACACAAAAATGCGGATGTAAGGCACTAGAGCATAAAAGCGATCTA", Sequence.find_by(quality: "5buj1j3hn1").dna
    assert_equal 41, Hit.find_by(match_gene_name: "vero").percent_similarity
  end
end
