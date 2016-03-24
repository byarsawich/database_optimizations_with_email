class MailReportJob < ActiveJob::Base
  queue_as :mail_report

  def perform(*args)
    assembly = Assembly.find_by(name: args[1])
    hits = assembly.hits.order(percent_similarity: :desc)
    filename = "report#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}.csv"
    file_path = Rails.root.join("tmp", filename)
    CSV.open("tmp/#{filename}", "w") do |csv|
      csv << ["Matching Gene Name", "Matching DNA", "Percent Similarity"]
      hits.each do |h|
        csv << [h.match_gene_name, h.match_gene_dna, h.percent_similarity]
      end
    end
    ReportMailer.send_report(args[0], file_path).deliver_now
  end
end
