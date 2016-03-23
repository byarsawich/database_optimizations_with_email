class ReportsController < ApplicationController
  helper_method :memory_in_mb

  def all_data
    @start_time = Time.now
    @assembly = Assembly.find_by_name(params[:name])
    @hits = @assembly.hits.order(percent_similarity: :desc)
    @memory_used = memory_in_mb
  end

  def search
  end

  def do_search
    @start_time = Time.now

    @hits = Hit.joins("JOIN genes ON genes.id = hits.subject_id AND hits.subject_type = 'Gene'")
        .joins("JOIN sequences ON sequences.id = genes.sequence_id")
        .joins("JOIN assemblies ON assemblies.id = sequences.assembly_id")
        .where("assemblies.name LIKE ? OR genes.dna LIKE ? OR hits.match_gene_name LIKE ?",
            "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
        .order("hits.percent_similarity DESC")

    @memory_used = memory_in_mb
    render 'all_data'
  end

  def upload

  end

  def thank_you
    uploaded_io = params[:filename]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end

    AddCsvJob.perform_later(uploaded_io.original_filename)
  end



  private def memory_in_mb
    `ps -o rss -p #{$$}`.strip.split.last.to_i / 1024
  end
end
