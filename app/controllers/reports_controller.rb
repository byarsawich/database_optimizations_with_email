class ReportsController < ApplicationController
  helper_method :memory_in_mb

  def all_data
    @name = params[:name]
  end

  def all_data_job
    @name = params[:name].chomp
    @address = params[:address].chomp
    if @address != "" && @name != ""
      MailReportJob.set(queue: :mail_report).perform_later(params[:address], params[:name])
      redirect_to thank_you_path
    else
      flash.now[:notice] = "Please fill in your email address for recieving your report."
      render :all_data
    end
  end

  def search
  end

  def search_job
    @search = params[:search].chomp
    @address = params[:address].chomp
    if @address != "" && @search != ""
      MailSearchJob.set(queue: :mail_search).perform_later(params[:address], params[:search])
      redirect_to thank_you_path
    else
      notice = ""
      if @address == ""
        notice += "Please fill in your email address for recieving your report. "
      end
      if @search == ""
        notice += "Please fill in a search paramater for your report."
      end
      flash.now[:notice] = notice
      render :search
    end
  end

  def report_thank_you
  end

  def upload
  end

  def upload_thank_you
    uploaded_io = params[:filename]
    path = Rails.root.join('tmp', uploaded_io.original_filename)
    File.open(path, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    AddCsvJob.set(queue: :import_csv).perform_later(path.to_s)
  end



  private def memory_in_mb
    `ps -o rss -p #{$$}`.strip.split.last.to_i / 1024
  end
end
