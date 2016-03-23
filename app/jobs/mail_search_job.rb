class MailSearchJob < ActiveJob::Base
  queue_as :mail_search

  def perform(*args)
    hits = Hit.joins("JOIN genes ON genes.id = hits.subject_id AND hits.subject_type = 'Gene'")
        .joins("JOIN sequences ON sequences.id = genes.sequence_id")
        .joins("JOIN assemblies ON assemblies.id = sequences.assembly_id")
        .where("assemblies.name LIKE ? OR genes.dna LIKE ? OR hits.match_gene_name LIKE ?",
            "%#{args[1]}%", "%#{args[1]}%", "%#{args[1]}%")
        .order("hits.percent_similarity DESC")

    filename = "report#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}.csv"
    file_path = Rails.root.join("tmp", filename)
    CSV.open("tmp/#{filename}", "w") do |csv|
      csv << ["Matching Gene Name", "Matching DNA", "Percent Similarity"]
      hits.each do |h|
        csv << [h.match_gene_name, h.match_gene_dna, h.percent_similarity]
      end
    end
  end
end
