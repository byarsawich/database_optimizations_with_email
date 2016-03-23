require 'test_helper'

class ReportMailerTest < ActionMailer::TestCase
  test "send_report" do
    mail = ReportMailer.send_report
    assert_equal "Send report", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
