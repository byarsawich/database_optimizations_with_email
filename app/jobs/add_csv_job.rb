class AddCsvJob < ActiveJob::Base
  queue_as :import_csv

  def perform(*args)
    CSV.foreach("#{Rails.root}/public/uploads/#{args[0]}", {headers: true}) do |row|
      a = Assembly.find_by(name: row["Assembly Name"])
      unless a
        a = Assembly.create(name: row["Assembly Name"], run_on: Date.today)
      end
      s = Sequence.find_by(dna: row["Sequence"])
      unless s
        s = Sequence.create(assembly_id: a.id, dna: row["Sequence"], quality: row["Sequence Quality"])
      end
      g = Gene.find_by(dna: row["Gene Sequence"])
      unless g
        g = Gene.create(sequence_id: s.id, dna: row["Gene Sequence"], starting_position: row["Gene Starting Position"], direction: row["Gene Direction"])
      end
      Hit.create(subject_id: g.id, subject_type: "Gene", match_gene_name: row["Hit Name"], match_gene_dna: row["Hit Sequence"], percent_similarity: row["Hit Similarity"])
    end
    File.delete("#{Rails.root}/public/uploads/#{args[0]}")
  end
end
