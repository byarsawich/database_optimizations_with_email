class ReportMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.report_mailer.send_report.subject
  #
  def send_report(address, file_path)
    @greeting = "Hi"
    @path = file_path

    attachments['report.csv'] = File.read(@path)
    mail to: address, subject: "Your Requested Report"
  end
end
